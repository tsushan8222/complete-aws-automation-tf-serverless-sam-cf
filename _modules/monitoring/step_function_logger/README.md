# Capture Failed Setp Function execution

## Working

### Event Payload

```json
{
  "version": "0",
  "id": "315c1398-40ff-a850-213b-158f73e60175",
  "detail-type": "Step Functions Execution Status Change",
  "source": "aws.states",
  "account": "012345678912",
  "time": "2019-02-26T19:42:21Z",
  "region": "us-east-1",
  "resources": [
    "arn:aws:states:us-east-1:012345678912:execution:state-machine-name:execution-name"
  ],
  "detail": {
    "executionArn": "arn:aws:states:us-east-1:012345678912:execution:state-machine-name:execution-name",
    "stateMachineArn": "arn:aws:states:us-east-1:012345678912:stateMachine:state-machine",
    "name": "execution-name",
    "status": "FAILED",
    "startDate": 1551225146847,
    "stopDate": 1551225151881,
    "input": "{}",
    "inputDetails": {
      "included": true
    },
    "output": null,
    "outputDetails": null
  }
}
```

Step Function execution status can be captured with AWS Cloudwatch event rule.

**Rule**

```json
{
  "source": ["aws.states"],
  "detail-type": ["Step Functions Execution Status Change"],
  "detail": {
    "status": ["FAILED", "TIMED_OUT", "ABORTED"]
  }
}
```

With this rule the event can be captured in Cloudwatch. For the event destination AWS Lambda is set.

#### Lambda Working

When the Lambda is triggered `executionArn` is passed in event details.

We can describe the statemachine executation history with `boto3.client('stepfunctions').get_execution_history(executionArn)`.

This method returns all the state execution history data as

```json
{
    "events": [
        {
            'timestamp': datetime(2015, 1, 1),
            'type': 'ActivityFailed'|'ActivityScheduled'|'ActivityScheduleFailed'|'ActivityStarted'|'ActivitySucceeded'|'ActivityTimedOut'|'ChoiceStateEntered'|'ChoiceStateExited'|'ExecutionAborted'|'ExecutionFailed'|'ExecutionStarted'|'ExecutionSucceeded'|'ExecutionTimedOut'|'FailStateEntered'|'LambdaFunctionFailed'|'LambdaFunctionScheduled'|'LambdaFunctionScheduleFailed'|'LambdaFunctionStarted'|'LambdaFunctionStartFailed'|'LambdaFunctionSucceeded'|'LambdaFunctionTimedOut'|'MapIterationAborted'|'MapIterationFailed'|'MapIterationStarted'|'MapIterationSucceeded'|'MapStateAborted'|'MapStateEntered'|'MapStateExited'|'MapStateFailed'|'MapStateStarted'|'MapStateSucceeded'|'ParallelStateAborted'|'ParallelStateEntered'|'ParallelStateExited'|'ParallelStateFailed'|'ParallelStateStarted'|'ParallelStateSucceeded'|'PassStateEntered'|'PassStateExited'|'SucceedStateEntered'|'SucceedStateExited'|'TaskFailed'|'TaskScheduled'|'TaskStarted'|'TaskStartFailed'|'TaskStateAborted'|'TaskStateEntered'|'TaskStateExited'|'TaskSubmitFailed'|'TaskSubmitted'|'TaskSucceeded'|'TaskTimedOut'|'WaitStateAborted'|'WaitStateEntered'|'WaitStateExited',
            'id': 123,
            'previousEventId': 123,
            'activityFailedEventDetails': {
                'error': 'string',
                'cause': 'string'
            }
    ],
    "nextToken": 'string'

    [[REDACTED]]
}
```

Steps

- Describe the execution history using ARN
- Grab Input to the state machine start execution in step `executionStartedEventDetails`
- Build execution history timeline to a data tree
- Map Unique State to state tree
- From TaskFailed type get error details and cause
- Walk backwarrds to find where the task was started
- Map input to that state from `TaskStateEntered` type
- Configure Data payload to be sent for notifications

Format

```json
"data": {
    "event_info": {
                "execution_arn ": event['detail']["execution_arn"],
                "state_machine_arn": event['detail']["state_machine_arn"],
                "execution_name ": event['detail']["execution_name"],
                "env": os.environ['ENV']
        },
    "event_details": {
        "payload": "input to step function",
        "steps": [
            "name": "Sate Machine Step Name",
            "initial_input": "Input to that step",
            "latest_error": {
                "error": "Error type",
                "cause": "cause with exception"
            }
        ]
    }
}
```

- Notify to dev `group_email` with emailType `INTERNAL_ENQUIRY_ERROR`
- Notify to CustomerAssist `group_email` with emailType `ASSESTIVE_ENQUIRY_ERROR`

**Notification way can be changed with lambda**

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | 2.18.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Application Name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment to which it runs | `string` | `"dev"` | no |
| <a name="input_event_rule_name"></a> [event\_rule\_name](#input\_event\_rule\_name) | AWS Cloudwatch Event Rule Name | `string` | n/a | yes |
| <a name="input_external_group_email"></a> [external\_group\_email](#input\_external\_group\_email) | External Group Email Address | `string` | n/a | yes |
| <a name="input_internal_group_email"></a> [internal\_group\_email](#input\_internal\_group\_email) | Internal Group Email Address | `string` | n/a | yes |
| <a name="input_notification_api"></a> [notification\_api](#input\_notification\_api) | Notification API URL | `string` | n/a | yes |
| <a name="input_step_function_arns"></a> [step\_function\_arns](#input\_step\_function\_arns) | List of Step Function ARNs to monitor | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
