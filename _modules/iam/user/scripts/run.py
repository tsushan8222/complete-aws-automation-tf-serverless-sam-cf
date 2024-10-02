import boto3
from botocore.exceptions import ClientError
import argparse
import subprocess
import sys

parser = argparse.ArgumentParser()
parser.add_argument('--useremail', required=True)
parser.add_argument('--passwd', required=True)
parser.add_argument('--region', required=True)
parser.add_argument('--sender', required=True)
parser.add_argument('--group', required=True)
parser.add_argument('--bcc_email_address', required=False, default="devops@homeloanexperts.com.au")

args = parser.parse_args()

cmd1 = ["echo", args.passwd]
cmd2 = ["base64", "-di"]
cmd3 = ["keybase", "pgp", "decrypt"]

p1 = subprocess.Popen(cmd1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
p2 = subprocess.Popen(cmd2, stdin = p1.stdout, stdout = subprocess.PIPE)
p3 = subprocess.Popen(cmd3, stdin = p2.stdout, stdout = subprocess.PIPE)
out, err = p3.communicate()
#print(out)
password = str(out)

# This address must be verified with Amazon SES.
SENDER = args.sender

RECIPIENT = args.useremail 

BCC = args.bcc_email_address

# set, comment the following variable, and the 
# ConfigurationSetName=CONFIGURATION_SET argument below.
#CONFIGURATION_SET = "ConfigSet"

# If necessary, replace us-west-2 with the AWS Region you're using for Amazon SES.
AWS_REGION = args.region

# The subject line for the email.
SUBJECT = "Initial password for AWS Console"

# The email body for recipients with non-HTML email clients.
BODY_TEXT = ("Amazon SES Test (Python)\r\n"
             "This email was sent with Amazon SES using the "
             "AWS SDK for Python (Boto)."
            )

BODY_HTML = "" 
        
if args.group == "[]":    
    # The HTML body of the email.
    BODY_HTML = """<html> <head></head>
    <body>
      <h1>Welcome to HLE tech team</h1>
      <p>Here are your AWS credentials to access AWS. <br>
        URL: <a href='https://hle.signin.aws.amazon.com/console'>AWS Console</a> <br>
        Account ID and account alias: <b> hle </b> <br>
        Username: <b> """ + args.useremail + """ </b> <br>
        password: <b> """ + password[2:-1] + """ </b> <br>
        <br>
        Once you sign in do create a strong password and store in Keeper. <br>
        After you logged in you can create access token from the console to access from CLI
      </p>
    </body>
    </html>
                """     
    # The character encoding for the email.
    CHARSET = "UTF-8"
else:
    # The HTML body of the email.
    BODY_HTML = """<html> <head></head>
    <body>
      <h1>Welcome to HLE tech team</h1>
      <p>Here are your AWS credentials to access AWS. <br>
        URL: <a href='https://hle.signin.aws.amazon.com/console'>AWS Console</a> <br>
        Account ID and account alias: <b> hle </b> <br>
        Username: <b> """ + args.useremail + """ </b> <br>
        password: <b> """ + password[2:-1] + """ </b> <br>
        <br>
        <b> Note: </b> You are associate to <b> """ + args.group[1:-1] + """ </b> group and your assume role name is <b> """ + args.group[1:-1] + """ </b>
        <br>
        Once you sign in do create a strong password and store in Keeper. <br>
        After you logged in you can create access token from the console to access from CLI
      </p>
    </body>
    </html>
                """     
    # The character encoding for the email.
    CHARSET = "UTF-8"


# Create a new SES resource and specify a region.
client = boto3.client('ses',region_name=AWS_REGION)

# Try to send the email.
try:
    #Provide the contents of the email.
    response = client.send_email(
        Destination={
            'ToAddresses': [
                RECIPIENT,
            ],
            'BccAddresses': [
                BCC,
            ],
        },
        Message={
            'Body': {
                'Html': {
                    'Charset': CHARSET,
                    'Data': BODY_HTML,
                },
                'Text': {
                    'Charset': CHARSET,
                    'Data': BODY_TEXT,
                },
            },
            'Subject': {
                'Charset': CHARSET,
                'Data': SUBJECT,
            },
        },
        Source=SENDER,
        # If you are not using a configuration set, comment or delete the
        # following line
#        ConfigurationSetName=CONFIGURATION_SET,
    )
# Display an error if something goes wrong.	
except ClientError as e:
    print(e.response['Error']['Message'])
else:
    print("Email sent! Message ID:"),
    print(response['MessageId'])