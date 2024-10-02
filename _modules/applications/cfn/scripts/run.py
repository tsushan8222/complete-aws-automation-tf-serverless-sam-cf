import os
import sys
import argparse
import subprocess
from subprocess import call,check_call
import argparse
import boto3
import re
import json
import base64
from time import time
import shutil
from shutil import make_archive
import errno
import tempfile
import magic
from distutils.util import strtobool
import tarfile
import uuid
from time import sleep


session = None
if sys.version_info < (3, 6):
    raise RuntimeError("A python version 3.6 or newer is required")

def copyDir(src, dest, patterns):
    try:
        shutil.copytree(src, dest, ignore=shutil.ignore_patterns(*patterns),dirs_exist_ok=True,ignore_dangling_symlinks =True)
    except OSError as e:
        # If the error was caused because the source wasn't a directory
        if e.errno == errno.ENOTDIR:
            shutil.copy(src, dest)
        else:
            print('Directory not copied. Error: %s' % e)
            sys.exit(1)


def genTempDir():

    try:
        tempdir = tempfile.mkdtemp(prefix="cfnpackage-")
        print("TempDir: ", tempdir)
        return tempdir
    except Exception as Error:
        print("Unable to create Directory")
        sys.exit(1)

def timer_func(func):
    # This function shows the execution time of 
    # the function object passed
    def wrap_func(*args, **kwargs):
        t1 = time()
        result = func(*args, **kwargs)
        t2 = time()
        print(f'Function {func.__name__!r} executed in {(t2-t1):.4f}s')
        return result
    return wrap_func

def boto_session(env, region="ap-southeast-2"):
    global session
    if "AWS_ACCESS_KEY_ID" in os.environ and "AWS_SECRET_ACCESS_KEY" in os.environ:
        session = boto3.Session(aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"), aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"), aws_session_token=os.getenv("AWS_SESSION_TOKEN"), region_name=region)
        return session
    session = boto3.Session(region_name=region)
    credentials = session.get_credentials()
    os.environ['AWS_ACCESS_KEY_ID'] = credentials.access_key
    os.environ['AWS_SECRET_ACCESS_KEY'] = credentials.secret_key
    os.environ['AWS_SESSION_TOKEN'] = credentials.token 
    os.environ['AWS_DEFAULT_REGION'] = region
    os.environ['AWS_REGION'] = region
    print('Done: Creating AWS Session for ' + env + ' on ' + region)
    return session


def describe_codebuild_project(project_name):
    global session
    print('Exporting Env variables for '+ project_name)
    code_build = session.client('codebuild')
    projects = code_build.batch_get_projects(names=[project_name])
    project_detail = projects['projects'][0]
    env_vars = project_detail['environment']['environmentVariables']
    plain_text_vars = list(filter(lambda v: v['type'] == 'PLAINTEXT', env_vars))
    parameter_store_vars = list(filter(
        lambda v: v['type'] == 'PARAMETER_STORE', env_vars))
    secret_manager_vars = list(filter(
        lambda v: v['type'] == 'SECRETS_MANAGER', env_vars))
    for i in range(len(plain_text_vars)):
        os.environ[plain_text_vars[i]['name']] = plain_text_vars[i]['value']
    parameter_store_client = session.client('ssm')
    for i in range(len(parameter_store_vars)):
        paramater_store_respose = parameter_store_client.get_parameters(
            Names=parameter_store_vars[i]['value'], WithDecryption=True)
        os.environ[parameter_store_vars[i]['name']
                   ] = paramater_store_respose['Parameters']['Value']
    secretsmanager_client = session.client('secretsmanager')
    for i in range(len(secret_manager_vars)):
        regex_pattern = ':' + secret_manager_vars[i]['name'] + '$'
        secret_arn = re.sub(regex_pattern , '', secret_manager_vars[i]['value'])
        get_secret_value_response = secretsmanager_client.get_secret_value(
            SecretId=secret_arn)
        if 'SecretString' in get_secret_value_response:
            secret = json.loads(get_secret_value_response['SecretString'])
        else:
            secret = json.loads(base64.b64decode(
                get_secret_value_response['SecretBinary']))
        for key, value in secret.items():
            os.environ[secret[key]] = value
    print('Done: Exporting Env variable for '+ project_name)


def prepare_env_vars(env_variables):
    env_string = ""
    for var in env_variables:
        try:
            value = os.environ[var]
            if " " in value or "'" in value :
                env_string += f"{var}=\"{value}\"\n"
            else:
                env_string += f"{var}={value}\n"
        except Exception as Error:
            print("Cannot find Environment Variable ", Error)
            sys.exit(1)
    return env_string


def get_code_build_dir():
    try:
        current_dir_location = os.environ['CODEBUILD_SRC_DIR']
        return current_dir_location
    except Exception as Error:
        print("Cannot find Location variable", Error)
        sys.exit(1)


def write_env_file_to_dir(env_string, file_path):
    env_file_path = os.path.join(file_path , '.env')
    try:
        with open(env_file_path, "w") as f:
            f.write(env_string)
    except Exception as Error:
        print("Failed to wite to a directory", Error)
        sys.exit(1)


def execute_script(script_path,cwd=None):
    print("Running Script on ", script_path)
    try:
        change_file_permission = os.chmod(script_path, 0o777)
    except Exception as Error:
        print("Failed to change the file permission")
        sys.exit(1)
    try:
        if cwd is None:
            run_script = check_call(script_path, shell=True)
        else:
            run_script = check_call(script_path, shell=True,cwd=cwd)
    except Exception as Error:
        print("Failed to run script", Error)
        sys.exit(1)


def get_aws_region():
    try:
        region = os.environ['AWS_REGION']
        return region
    except:
        return "ap-southeast-2" 


def get_env():
    try:
        env = os.environ['ENV'].lower()
        return env
    except:
        return 'dev'


def gen_parameter_override(templatedir,file_name,deployment_id):
    try:
        file_path = os.path.join(templatedir,file_name)
        # os.environ['PARAMETER_OVERRIDE'] = json.dumps({"Parameters": {}}) # for testing purposes only
        para = os.environ['PARAMETER_OVERRIDE']
        para_json = json.loads(para)
        para_json['Parameters']['deploymentId'] = str(deployment_id)
        print("Deployment ID ",str(deployment_id))
        with open(file_path, "w+") as f:
            f.write(json.dumps(para_json, indent = 2))
    except Exception as Error:
        print("Failed to create parameter override file ", Error)
        sys.exit(1)

def printStackErrors(stackName):
    global session
    client = session.client('cloudformation')
    try:
        events = client.describe_stack_events(StackName=stackName)
    except Exception as e:
        if 'Rate exceeded' in str(e):
            sleep(5)
            print("Stack Error", str(e))
            return 
        else:  
            print("Stack Error", str(e))
            return
    for event in events['StackEvents']:
        if event['ResourceStatus'] == 'CREATE_FAILED' or event['ResourceStatus'] == 'UPDATE_FAILED' or event['ResourceStatus'] == 'UPDATE_ROLLBACK_IN_PROGRESS':
            print(event['LogicalResourceId'] + " - " + event['ResourceStatusReason'])

def cfn_package(bucket_name,prefix,templatedir,template_input_file,template_output_file):
    print("Creating Package for ", os.path.join(templatedir,template_input_file))
    try:
        cfn_package_response = subprocess.run([
            "aws",
            "cloudformation",
            "package",
            "--template-file",
            os.path.join(templatedir,template_input_file),
            "--s3-bucket",
            bucket_name,
            "--s3-prefix",
            prefix,
            "--output-template-file",
            os.path.join(templatedir,template_output_file)
            ],cwd=templatedir,check=True)
        return cfn_package_response
    except Exception as Error:
        print("CFN Packaging Failed ", Error)
        sys.exit(1)


def cfn_deploy(bucket_name,prefix,templatedir,template_file,role,region,parameter_override_file):
    try:
        stack_name = 'stack-' + get_env() + '-' + role
        cfn_deploy_response = subprocess.run([
            "aws",
            "cloudformation",
            "deploy",
            "--no-fail-on-empty-changeset",
            "--template-file",
            os.path.join(templatedir,template_file),
            "--s3-bucket",
            bucket_name,
            "--s3-prefix",
            prefix,
            "--stack-name",
            stack_name,
            "--region",
            region,
            "--capabilities",
            "CAPABILITY_AUTO_EXPAND",
            "CAPABILITY_NAMED_IAM",
            "CAPABILITY_IAM",
            "--parameter-overrides",
            "file://" + os.path.join(templatedir,parameter_override_file)
            ],cwd=templatedir,check=True)
        return cfn_deploy_response
    except Exception as Error:
        print("CFN Deployment Failed ", Error)
        printStackErrors(stack_name)
        sys.exit(1)


def validate_template(templatedir,template_file):
    print("Validating template ",os.path.join(templatedir,template_file))
    try:
        cfn_validate_response = subprocess.run([
            "aws",
            "cloudformation",
            "validate-template",
            "--template-body",
            "file://" + os.path.join(templatedir,template_file)
            ],cwd=templatedir,check=True)
        return cfn_validate_response
    except Exception as Error:
        print("Template Validation Failed ", Error)
        sys.exit(1)


def get_most_recent_s3_object(bucket_name, prefix):
    global session
    try:
        s3 = session.client('s3')
        paginator = s3.get_paginator( "list_objects_v2" )
        page_iterator = paginator.paginate(Bucket=bucket_name, Prefix=prefix)
        latest = None
        for page in page_iterator:
            if "Contents" in page:
                latest = max(page['Contents'], key=lambda x: x['LastModified'])
        print("Latest deploymentId: ", latest['Key'])
        return latest['Key']
    except Exception as Error:
        print("Failed to retrive latest deployment object key ", Error)
        sys.exit(1)

def syncS3website(stack_name,bucket_name_pattern,src,dest=''):
    global session
    try:
        cf = session.client('cloudformation')
        response = cf.describe_stacks(StackName=stack_name)
        s3location = None
        for idx in response['Stacks'][0]['Outputs']:
            if idx['OutputKey'] == 'BucketName' and re.match(bucket_name_pattern, idx['OutputValue']) != None:
                s3location = idx['OutputValue']
        if s3location == None:
            print("Failed to locate bucket with pattern ", bucket_name_pattern)
            sys.exit(1)
    except Exception as Error:
        print("Failed to Locate S3 Bucket on Stack Outputs: ", Error)
        sys.exit(1)
    try:
        s3 = session.client('s3')
        print("Syncing Dir", src)
        for root,dirs,files in os.walk(src):
            for file in files:
                filename, file_extension = os.path.splitext(file)
                # WORK AROUND FOR ISSUE IN LIBMAGIC
                if file_extension == '.css':
                    mType = 'text/css'
                elif file == 'sw.js' or file == 'serviceWorker.js' or file == 'service-worker.js':
                    mType = 'application/javascript'
                else:
                    mime = magic.Magic(mime=True)
                    mType = mime.from_file(os.path.join(root,file))

                thisDir = root.replace(src,"")
                target = thisDir +'/' +file
                target = target[1:]
                target = dest + target
                print("Syncing ", target)
                s3.put_object(ACL='public-read',Body=open(os.path.join(root,file), "rb").read(),Bucket=s3location,Key=target,ContentType=mType)  
    except Exception as Error:
        print("Failed to Sync to S3 : ", s3location)
        sys.exit(1)

def remove(path):
    """ param <path> could either be relative or absolute. """
    if os.path.isfile(path) or os.path.islink(path):
        os.remove(path)  # remove the file
    elif os.path.isdir(path):
        shutil.rmtree(path)  # remove dir and all contains
    else:
        raise ValueError("file {} is not a file or dir.".format(path))

def archiveDir(src, dest,archive_filename):
    try:
        dirs = os.listdir(src)
        print("Dir..", dirs)
        file_path = os.path.join(dest, archive_filename)
        print("Archive file path : ",file_path)
        with tarfile.open( file_path+ '.tar.gz', "w:gz") as tar:
            tar.add(src,arcname='')

    except Exception as Error:
        print("Failed to create archive ", Error)

def uploadToS3(bucket_name,src,dest):
    global session
    try:
        s3 = session.client('s3')
        s3.upload_file(src,bucket_name,dest)
    except Exception as Error:
        print("Failed to upload to s3 ", Error)
        sys.exit(1)
def downloadFromS3(bucket_name,src,dest):
    print("Downloading " + src + " from " +bucket_name + " and writing to " + dest)
    global session
    try:
        s3 = session.resource('s3')
        s3.meta.client.download_file(bucket_name,src,dest)
    except Exception as Error:
        print("Failed to Download and Write to Dir ", Error)
        sys.exit(1)
def argparser():
    parser = argparse.ArgumentParser()
    parser.add_argument('-td', '--template_yaml_dir', required=True,
                        help="SAM YAML Directory Location")
    parser.add_argument('-tfi', '--template_input_file_name', required=True,
                        help="CloudFormation/SAM template file name")
    parser.add_argument('-tfo', '--template_output_file_name', required=True,
                        help="CloudFormation/SAM template file name rendred file name")
    parser.add_argument('-pof', '--parameter_override_file_name', required=True,
                        help="Parameter Override File Name")
    parser.add_argument('-ar', '--app_role', required=True,
                        help="Application Role")
    parser.add_argument('-cd', '--code_dir',help="Code Root Dir",required=False)
    parser.add_argument('-cp', '--codebuild_project_name', required=False,
                        help="CodeBuild Project Name")
    parser.add_argument('-ue', '--use_autogenerated_dot_env', required=True,
                        help="Use autogenerated env", default=True,type=lambda x: bool(strtobool(x)))
    parser.add_argument('-up', '--use_autogenerated_parameters', required=True,
                        help="Use autogenerated parameter", default=True,type=lambda x: bool(strtobool(x)))
    parser.add_argument('-eo', '--envoutput', required=True,
                        help="dot env file output location")
    parser.add_argument('-ev', '--envvars', default=[], nargs="+", required=True,
                        help="dot env file output location")
    parser.add_argument('-ig', '--ignore_patterns', default=[], nargs="+", required=True,
                        help="Folder exclude patterns to ignore from packaging")
    parser.add_argument('-s3b', '--bucket_name_pattern', default=None,
                        help="Bucket Name Regular expression pattern")
    parser.add_argument('-ds', '--dir_to_sync', default=None,
                        help="Dir to sync to S3")
    parser.add_argument('-pps', '--pre_package_sh_location', default='',
                        help="Prepackage script file path with file name")
    parser.add_argument('-pp', '--post_package_sh_location', default='',
                        help="Postpackage script file path with file name")
    parser.add_argument('-pds', '--pre_deploy_sh_location', default='',
                        help="Postdeployment script file path with file name")
    parser.add_argument('-pd', '--post_deploy_sh_location', default='',
                        help="Postdeployment script file path with file name")
    parser.add_argument('-ci', '--ci_only',
                        help="Run Continuous Integration Only",type=lambda x: bool(strtobool(x)))
    parser.add_argument('-role', '--use_pipeline_application_role',
                        help="Controls what role to use when deploying",type=lambda x: bool(strtobool(x)))
    return parser

@timer_func
def main():
    try:
        ap = argparser().parse_args()

        # Create AWS SESSION
        session = boto_session(get_env(),get_aws_region())
        
        if ap.code_dir == '' or ap.code_dir == 'null' or ap.code_dir == None:
            code_build_dir = get_code_build_dir()
        else :
            code_build_dir = os.path.normpath(os.path.join(os.getcwd(),ap.code_dir))

        print("Root CodeBuild Dir: ",code_build_dir)
        root_code_build_dir = code_build_dir
        # Create a temp Dir
        code_build_dir = genTempDir()
        # Copy to temp directory
        copyDir(root_code_build_dir, code_build_dir, ap.ignore_patterns)

        template_yaml_dir = os.path.normpath(os.path.join(code_build_dir,ap.template_yaml_dir))
        print("CFN TEMPLATE DIR ", template_yaml_dir)
        bucket_name = 'hle-' + get_env() +'-' + get_aws_region() + '-artifact-bucket'
        role = ap.app_role
        if ap.use_pipeline_application_role ==True and os.getenv('APPLICATION_ROLE', False):
            role = os.getenv('APPLICATION_ROLE')
        # Retrive CodeBuild env variable if project name is specified
        if ap.use_autogenerated_dot_env == True and ap.codebuild_project_name != 'null' and ap.codebuild_project_name != None:
            describe_codebuild_project(ap.codebuild_project_name)
        if ap.use_autogenerated_dot_env == True:
            env_file_location = os.path.normpath(os.path.join(code_build_dir,ap.envoutput))
            print("ENV FILE LOCATION ", env_file_location)
            env_variables = ap.envvars
            env_vars_string = prepare_env_vars(env_variables)
            write_env_file_to_dir(env_vars_string, env_file_location)
            write_env_file_to_dir(env_vars_string, os.path.normpath(os.path.join(root_code_build_dir, ap.envoutput)))

        if ap.pre_package_sh_location != '' and ap.pre_package_sh_location != 'null' and ap.pre_package_sh_location != None:
            print("Running Script before packaging")
            execute_script(os.path.normpath(os.path.join(code_build_dir,ap.pre_package_sh_location)),code_build_dir)
        # Start to Package
        prefix = 'packages/' + role
        #Package
        cfn_package(bucket_name,prefix,template_yaml_dir,ap.template_input_file_name,ap.template_output_file_name)
        # manually package if S3 Site is specified
        s3_sync_archive = None
        if ap.dir_to_sync != '' and ap.dir_to_sync != 'null' and ap.dir_to_sync != None:
            # Create archive
            dir_to_sync = os.path.normpath(os.path.join(code_build_dir,"/build")) if ap.dir_to_sync == None else os.path.normpath(os.path.join(code_build_dir,ap.dir_to_sync))
            s3_sync_archive = str(uuid.uuid4())
            archiveDir(src = dir_to_sync, dest = code_build_dir,archive_filename= s3_sync_archive)
            #Upload to S3
            uploadToS3(bucket_name = bucket_name,src=os.path.join(code_build_dir,s3_sync_archive + ".tar.gz") ,dest = prefix + '/' + s3_sync_archive + ".tar.gz")
        #Validate Template
        validate_template(template_yaml_dir,ap.template_output_file_name)
        #Run Post Package Script 
        if ap.post_package_sh_location != '' and ap.post_package_sh_location != 'null' and ap.post_package_sh_location != None:
            print("Running Script after packaging")
            execute_script(os.path.normpath(os.path.join(code_build_dir,ap.post_package_sh_location)),code_build_dir)

        # Exit if Continuous  Integration Only
        if ap.ci_only == True or os.getenv('CI_ONLY',False) :
            return "Successfully ran Continuous Integration"
        #Run Pre Deploy Script 
        if ap.pre_deploy_sh_location != '' and ap.pre_deploy_sh_location != 'null' and ap.pre_deploy_sh_location != None:
            print("Running Predeploy Script")
            execute_script(os.path.normpath(os.path.join(code_build_dir,ap.pre_deploy_sh_location)),code_build_dir)

        parameter_override_file = ap.parameter_override_file_name
        #Retrive last packaged version from S3
        if s3_sync_archive == None:
            deployment_id = get_most_recent_s3_object(bucket_name, prefix)
        else:
            deployment_id = prefix + '/' + s3_sync_archive + ".tar.gz"
        #parameter Injection ( parameter will be available as JSON string on env['PARAMETER_OVERRIDE'])
        if ap.use_autogenerated_parameters != True:
            with open(os.path.join(template_yaml_dir,parameter_override_file)) as f:
                data = json.load(f)
                os.environ["PARAMETER_OVERRIDE"] = json.dumps(data)
        
        gen_parameter_override(template_yaml_dir,parameter_override_file,deployment_id)
        gen_parameter_override(os.path.normpath(os.path.join(root_code_build_dir, ap.template_yaml_dir)), parameter_override_file, deployment_id)
        # Deploy the Stack
        cfn_deploy(bucket_name,prefix,template_yaml_dir,ap.template_output_file_name,role,get_aws_region(),parameter_override_file)

        # If S3 sync is specified
        if s3_sync_archive != None and s3_sync_archive !='' and ap.bucket_name_pattern != None and ap.bucket_name_pattern !='':
            download_dir = os.path.join(code_build_dir,'s3')
            os.mkdir(download_dir)
            downloadFromS3(bucket_name = bucket_name ,src = deployment_id  ,dest = download_dir+s3_sync_archive+ ".tar.gz")
            dir_to_sync = os.path.join(download_dir , 'sync')
            with tarfile.open(download_dir + s3_sync_archive + ".tar.gz") as tar:
                tar.extractall(dir_to_sync)
            syncS3website(stack_name= 'stack-' + get_env() + '-' + role ,bucket_name_pattern = ap.bucket_name_pattern,src=dir_to_sync)
        #Run Post Deploy Script 
        if ap.post_deploy_sh_location != '' and ap.post_deploy_sh_location != 'null' and ap.post_deploy_sh_location != None:
            print("Running Post Deploy Script")
            execute_script(os.path.normpath(os.path.join(code_build_dir,ap.post_deploy_sh_location)),code_build_dir)
    except Exception as Error:
        print("An error occurred ",Error)
    finally:
        if code_build_dir != None and code_build_dir !="":
            print("Deleting Temp Files and Folder for CleanUp 🗑️")
            remove(code_build_dir)



if __name__ == "__main__":
    main()
