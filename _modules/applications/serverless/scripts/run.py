import os
import sys
import argparse
import subprocess
from subprocess import call
import argparse

if sys.version_info < (3, 6):
    raise RuntimeError("A python version 3.6 or newer is required")


def prepare_env_vars(env_variables):
    env_string = ""
    for var in env_variables:
        try:
            os.environ[var]
            env_string += f"{var}={os.environ[var]}\n"
        except Exception as Error:
            print("Cannot find Environment varibale", Error)
            sys.exit(1)
    return env_string


def get_code_build_dir():
    try:
        current_dir_location = os.environ['CODEBUILD_SRC_DIR']
        return current_dir_location
    except Exception as Error:
        print("Cannot find Location varibale", Error)
        sys.exit(1)


def write_env_file_to_dir(env_string, file_path):
    env_file_path = os.path.join(file_path , '.env')
    try:
        with open(env_file_path, "w") as f:
            f.write(env_string)
    except Exception as Error:
        print("Failed to wite to a directory", Error)
        sys.exit(1)


def execute_script(script_path):
    print("Running Script on ", script_path)
    try:
        change_file_permission = os.chmod(script_path, 0o777)
    except Exception as Error:
        print("Failed to change the file permission")
        sys.exit(1)
    try:
        run_script = call(script_path, cwd = os.path.dirname(script_path), shell=True)
    except Exception as Error:
        print("Failed to run script", Error)
        sys.exit(1)


def get_aws_region():
    try:
        region = os.environ['AWS_REGION']
        return region
    except:
        sys.exit(1)


def get_env():
    try:
        env = os.environ['ENV'].lower()
        return env
    except:
        sys.exit(1)


def run_serverless_deploy(serverless_yaml_dir, env, region):
    print("running Serverless deployement")
    try:
        run_serverless_deploy = subprocess.run(
            ["serverless", "deploy", "-s", env, "-r", region], cwd=serverless_yaml_dir, check=True)
    except Exception as Error:
        print("Serverless deploy failed", Error)
        sys.exit(1)


def argparser():
    parser = argparse.ArgumentParser()
    parser.add_argument('-sd', '--serverlessdir', required=True,
                        help="Serverless YAML Directory Location")
    parser.add_argument('-eo', '--envoutput', required=True,
                        help="dot env file output location")
    parser.add_argument('-v', '--envvars', default=[], nargs="+", required=True,
                        help="dot env file output location")
    parser.add_argument('-bs', '--beforescript', default='',
                        help="before script file path with file name")
    parser.add_argument('-af', '--afterscript', default='',
                        help="before script file path with file name")
    return parser


def main():
    ap = argparser().parse_args()
    code_build_dir = get_code_build_dir()
    serveless_yaml_dir = os.path.normpath(os.path.join(code_build_dir,ap.serverlessdir))
    print("Serverless DIR ", serveless_yaml_dir)
    env_file_location = os.path.normpath(os.path.join(code_build_dir,ap.envoutput))
    print("ENV FILE LOCATION ", env_file_location)
    env_variables = ap.envvars
    before_deploy_sh_location = os.path.normpath(os.path.join(code_build_dir,ap.beforescript))
    print("Before Script FILE LOCATION ", before_deploy_sh_location)
    after_deploy_sh_location = os.path.normpath(os.path.join(code_build_dir,ap.afterscript))
    print("After Script FILE LOCATION ", after_deploy_sh_location)
    env_vars_string = prepare_env_vars(env_variables)
    write_env_file_to_dir(env_vars_string, env_file_location)
    if ap.beforescript != '' and ap.beforescript != 'null' and ap.beforescript != None:
        print("Running Before Deploy Script")
        execute_script(before_deploy_sh_location)
    run_serverless_deploy(
        serveless_yaml_dir, get_env(), get_aws_region())
    if ap.afterscript != '' and ap.afterscript != 'null' and ap.afterscript != None:
        print("Running After Deploy Script")
        execute_script(after_deploy_sh_location)


if __name__ == "__main__":
    main()
