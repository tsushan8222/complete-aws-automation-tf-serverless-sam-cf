import boto3
import json
import datetime
from dateutil.tz.tz import tzlocal
import requests
import os

sfn = boto3.client('stepfunctions')


def lambda_handler(event, context):
    try:
        event_payload = json.loads(json.dumps(event, indent=2, default=str))
        print("Event Payload: " ,event_payload)
        step_function_exc = get_execution_history_info(event_payload)
        print("Resonse ",step_function_exc)
        notify(to=os.environ['INTERNAL_GROUP_EMAIL'],data= step_function_exc,emailType = 'INTERNAL_FACTFIND_ERROR',ccTo=os.environ['EXTERNAL_CC_GROUP_EMAIL'])
        notify(to=os.environ['EXTERNAL_GROUP_EMAIL'],data= step_function_exc,emailType = 'ASSESTIVE_FACTFIND_ERROR',ccTo=os.environ['EXTERNAL_CC_GROUP_EMAIL'])
        return {
            'statusCode': 200,
            'message': "Successfully sent notification"
        }
    except Exception as error:
        print("Error ", error)
        return {
            'statusCode': 500,
            'message': "Service Error"
        }

def get_execution_history_info(event):
    exec_history = describe_step_function_execution(event['detail']["executionArn"])
    result = build_state_tree(exec_history['events'])
    result['steps'] = list(filter(lambda s: 'latest_error' in s , result['steps']))
    return {
        "data": {
            "event_info": {
                        "execution_arn": event['detail']["executionArn"],
                        "state_machine_arn": event['detail']["stateMachineArn"],
                        "execution_name ": event['detail']["name"],
                        "env": os.environ['ENV']
                },
            "event_details": result
            }
    }

def describe_step_function_execution(arn):
    response = sfn.get_execution_history(
        executionArn=arn,
        maxResults=1000,
        reverseOrder=False,
        includeExecutionData=True
    )
    return json.loads(json.dumps(response, indent=2, default=str))

def build_state_tree(execution_steps):
    data_tree = {
        "payload": {},
        "steps": []
    }
    for idx, step in enumerate(execution_steps):
        if step['type'] == 'ExecutionStarted' and step['id'] == 1:
            data_tree['payload'] = step['executionStartedEventDetails']['input']
        if step['type'] == 'TaskStateEntered':
            if not check_if_step_exists_in_dt(data_tree,step['stateEnteredEventDetails']['name']):
                data_tree['steps'].append({
                    'name': step['stateEnteredEventDetails']['name'],
                    'initial_input' : step['stateEnteredEventDetails']['input'],
                    'timestamp': step['timestamp']
                })
        if step['type'] == 'TaskFailed':
            current_step = walk_tree_to_find_step(execution_steps,idx)
            if current_step:
                for idx, tree_step in enumerate(data_tree['steps']):
                    if tree_step['name'] == current_step['name']:
                        tree_step['latest_error'] = {
                            'error': step['taskFailedEventDetails']['error'],
                            'cause': step['taskFailedEventDetails']['cause'],
                            'timestamp': step['timestamp']
                        }
                        break
        if step['type'] == 'TaskTimedOut':
            current_step = walk_tree_to_find_step(execution_steps,idx)
            if current_step:
                for idx, tree_step in enumerate(data_tree['steps']):
                    if tree_step['name'] == current_step['name']:
                        tree_step['latest_error'] = {
                            'error': step['taskTimedOutEventDetails']['error'],
                            'cause': "Task Timed Out",
                            'timestamp': step['timestamp']
                        }
                        break
    return data_tree

def check_if_step_exists_in_dt(tree, step):
    filterd_data = list(filter(lambda s: s['name'] == step , tree['steps']))
    return True if len(filterd_data) > 0 else False

def walk_tree_to_find_step(tree,current_position):
    step = {}
    for i in range(current_position-1, -1, -1):
        if tree[i]['type'] == 'TaskStateEntered' :
            step['name'] = tree[i]['stateEnteredEventDetails']['name']
            step['input'] = tree[i]['stateEnteredEventDetails']['input']
            break
    return step

def notify(to,data,emailType,ccTo):
    try:
        response = requests.post(os.environ['NOTIFICATION_API_URL'], json={"receipentEmailAddress": to, "emailType": emailType, "data": data, "ccRecipient": ccTo.split()} ,headers = {"Content-Type": "application/json"})
        return response
    except Exception as error:
        print("Error Sending Email ", error)
