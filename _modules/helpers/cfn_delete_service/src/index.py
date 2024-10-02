import os
import sys
import boto3
import re
import json
from hmac import HMAC, compare_digest
from hashlib import sha1
import uuid


def verify_signature(req):
    received_sign = req['headers'][
        'x-hub-signature'].split('sha1=')[-1].strip()
    secret = os.environ['GITHUB_SHARED_SECRET'].encode('utf-8')
    expected_sign = HMAC(
        key=secret, msg=req['body'].encode('utf-8'), digestmod=sha1).hexdigest()
    return compare_digest(received_sign, expected_sign)


def construct_branch_name(payload):
    if payload['ref_type'] == 'tag':
        sys.exit(1)
    raw_branch = payload['ref']
    cleaned_branch_name = re.sub("[^(release|hotfix)]+.$", "", raw_branch).replace("hotfix","release")
    cleaned_branch_name = cleaned_branch_name.replace(
        'refs/heads/', '').replace('@', '').replace('/', '-').replace(' ', '').replace('.','-').replace('$', '').lower()
    trim_to_len = cleaned_branch_name[:20]
    return trim_to_len


def get_env():
    try:
        env = os.environ['ENV'].lower()
        return env
    except:
        sys.exit(1)


def get_sns_arn():
    try:
        return os.environ['SNS_ARN']
    except:
        sys.exit(1)


def construct_repo_path(payload):
    return payload['repository']['full_name'].replace('/', '-').lower()


def construct_stack_name(repo_path, branch_name, env):
    return env + '-' + repo_path + '-' + branch_name


def get_all_s3_bucket_on_stack(stack_name):
    cfn = boto3.client('cloudformation')
    response = cfn.list_stack_resources(StackName=stack_name)
    results = response["StackResourceSummaries"]
    while "NextToken" in response:
        response = cfn.list_stack_resources(
            StackName=stack_name, NextToken=response["NextToken"])
        results.extend(response["StackResourceSummaries"])
    bucket_names = [resource['PhysicalResourceId']
                    for resource in results if resource['ResourceType'] == 'AWS::S3::Bucket']
    sns_logger(message="Gatharing buckets on stack: " + stack_name + " " +
               json.dumps(bucket_names))

    return bucket_names


def delete_all_bucket_objects(buckets=[]):
    s3 = boto3.resource('s3')
    for bucket in buckets:
        try:
            b = s3.Bucket(bucket)
            sns_logger(message="Deleting " + bucket + "objects")
            b.objects.all().delete()
        except Exception as error:
            print("Deleting Objects failed: ", error)


def delete_cfn_stack(stack_name):
    print("Deleting the stack: ", stack_name)
    try:
        cfn = boto3.client('cloudformation')
        sns_logger(message="Deleting stack " + stack_name)
        response = cfn.delete_stack(
            StackName=stack_name, ClientRequestToken=str(uuid.uuid4()))
    except Exception as error:
        print("Failed to delete: ", stack_name, error)
        sns_logger(message="Failed to delete " + stack_name)


def sns_logger(message):
    try:
        sns = boto3.client('sns')
        response = sns.publish(TopicArn=get_sns_arn(), Message=message)
    except:
        print("Failed to publish message on topic")


def lambda_handler(event, context):
    # Note: You will not receive a webhook for this event when you delete more than three tags at once.
    print("Payload: ", event)
    data = json.loads(event['body'])
    branch_name = construct_branch_name(data)
    repo_name = construct_repo_path(data)
    env = get_env()
    if not verify_signature(event):
        sns_logger("Signature validation failed")
        sys.exit(1)
    stack_name = construct_stack_name(
        repo_path=repo_name, branch_name=branch_name, env=env)
    buckets = get_all_s3_bucket_on_stack(stack_name=stack_name)
    delete_all_bucket_objects(buckets=buckets)
    print("Deleted All bucket objects")
    delete_cfn_stack(stack_name=stack_name)
    return {
        "statusCode": 200,
        "message": "successfully deleted " + stack_name
    }
