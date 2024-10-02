import json
import boto3
import os
import requests

def codebuild_slack_payload_generator(data):
    project_name = data['detail']['project-name'] if 'project-name' in data['detail'] else 'N/A'
    git_url = data['detail']['additional-information']['source']['location'] if 'location' in data['detail']['additional-information']['source'] else 'N/A'
    triggered_by = data['detail']['additional-information']['initiator'] if 'initiator' in data['detail']['additional-information'] else 'N/A'
    logs_deep_link = data['detail']['additional-information']['logs']['deep-link'] if 'deep-link' in data['detail']['additional-information']['logs'] else 'N/A'
    phases = data['detail']['additional-information']['phases'] if 'phases' in data['detail']['additional-information'] else []

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
        },
        {
            "type": "divider"
        },
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": "Deployment Phases  🕖",
                "emoji": True
            }
        },
        {
            "type": "divider"
        }
    ]
    }
    for phase in phases:
        template['blocks'].extend(
        [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"Deployment Phase: `{phase['phase-type']}`" if 'phase-type' in phase else "N/A"
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"Deployment Status: *{phase['phase-status']}*" if 'phase-status' in phase else "N/A"
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"Started At: `{phase['start-time']}`" if 'start-time' in phase else "N/A"
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"Completed At: `{phase['end-time']}`" if 'end-time' in phase else "N/A"
                }
            }
        ]
    )
    return template['blocks']



def lambda_handler(event, context):
    print('DEBUG Original:', event)
    channel = os.environ['SLACK_CHANNEL']
    WEBHOOK_URL = os.environ['SLACK_WEBHOOK']
    sns = event['Records'][0]['Sns']
    subject = 'DevOps Message'
    message = sns['Message']
    payload = {
        'text': message,
        'channel': channel,
        'username': subject
    }
    try:
        json_message = json.loads(message)
        if 'source' in json_message and json_message['source'] == 'aws.codebuild':
            subject = 'AWS CodeBuild ⚡'
            json_message_block =  codebuild_slack_payload_generator(json_message)
            payload = {
                    'text': "Deployment Notification",
                    'blocks': json_message_block,
                    'channel': channel,
                    'username': subject
            }
    except Exception as parseError:
        print("Failed to parse message",parseError)

    print('DEBUG  Slack :', payload)
    response = requests.post(WEBHOOK_URL, json=payload ,headers = {"Content-Type": "application/json"})
    if response.status_code != 200:
        raise ValueError(
            f"Request to slack returned an error {response.status_code}, "
            f"the response is:\n{response.text}"
        )
    return response.status_code