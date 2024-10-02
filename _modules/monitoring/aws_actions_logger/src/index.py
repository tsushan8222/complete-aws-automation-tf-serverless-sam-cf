import json
import boto3
import os
import requests


def lambda_handler(event, context):
    print('DEBUG: ',event)
    channel = os.environ['SLACK_CHANNEL']
    WEBHOOK_URL = os.environ['SLACK_WEBHOOK']
    sns = event['Records'][0]['Sns']
    subject = 'AWS Actions'
    message = json.loads(sns['Message'])
    if "eventSource" in message['detail'] and message['detail']['eventSource'] == "cloudformation.amazonaws.com":
        message = f"Action: {message['detail']['eventName']} on {message['detail']['requestParameters']['stackName']}  on {os.environ['ENV']} environment"
    payload = {
        'text': message,
        'channel': channel,
        'color': 'good',
        'username': subject
    }

    print('Slack Payload:', payload)
    r = requests.post(WEBHOOK_URL, json=payload)
    print('Slack Payload: Sent successfully')
    return r.status_code
