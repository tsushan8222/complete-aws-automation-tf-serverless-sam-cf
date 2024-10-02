import json
import boto3
import os
import requests


def codebuild_slack_payload_generator(data):
    project_name = data['detail']['project-name'] if 'project-name' in data['detail'] else 'N/A'
    build_status = data['detail']['build-status']
    git_url = data['detail']['additional-information']['source']['location'] if 'location' in data['detail']['additional-information']['source'] else 'N/A'
    triggered_by = data['detail']['additional-information']['initiator'] if 'initiator' in data['detail']['additional-information'] else 'N/A'
    logs_deep_link = data['detail']['additional-information']['logs']['deep-link'] if 'deep-link' in data['detail']['additional-information']['logs'] else 'N/A'
    template = {
    "blocks": [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": "Code Build Deployment Status ⚙",
                "emoji": True
            }
        },
        {
            "type": "divider"
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": f"Name: *{project_name}*"
            }
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": f"Git_URL: {git_url}"
            }
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": f"Deployment Triggered By: *{triggered_by}*"
            }
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": f"Status *{build_status}*"
            }
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "View Full Deployment *Logs*"
            },
            "accessory": {
                "type": "button",
                "text": {
                    "type": "plain_text",
                    "text": "View Logs 🕵️‍",
                    "emoji": True
                },
                "value": "click_me_123",
                "url": f"{logs_deep_link}",
                "action_id": "button-action"
            }
        }
    ]
    }
    return template['blocks']


def lambda_handler(event, context):
    print('DEBUG: ',event)
    channel = os.environ['SLACK_CHANNEL']
    WEBHOOK_URL = os.environ['SLACK_WEBHOOK']
    sns = event['Records'][0]['Sns']
    subject = 'CodeBuild Status'
    message = sns['Message']
    try:
        json_message = json.loads(message)
        if 'source' in json_message and json_message['source'] == 'aws.codebuild':
            subject = 'AWS CodeBuild Status 🔕'
            json_message_block =  codebuild_slack_payload_generator(json_message)
            payload = {
                    'text': "CodeBuild Status",
                    'blocks': json_message_block,
                    'channel': channel,
                    'username': subject
            }
            print('Slack Payload:', payload)
            response = requests.post(WEBHOOK_URL, json=payload ,headers = {"Content-Type": "application/json"})
            print('Slack Payload: Sent successfully')
            return response.status_code
    except Exception as parseError:
        print("Failed to parse message",parseError)
