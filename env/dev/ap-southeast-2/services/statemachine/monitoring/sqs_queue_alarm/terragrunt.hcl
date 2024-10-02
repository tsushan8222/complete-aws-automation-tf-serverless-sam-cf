include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../notify_using_email"]
}

dependency "notify_sns_arn" {
  config_path = "../notify_using_email"
}
terraform {
  source = "${get_parent_terragrunt_dir()}/../_modules/monitoring/sqs/cloudwatch_metric_alarm"
}

locals {
  global_environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  queue_name              = "${local.global_environment_vars.locals.environment}-enquiry-queue-dlq.fifo"
}

inputs = {
  env                 = local.global_environment_vars.locals.environment
  alarm_name          = "${local.global_environment_vars.locals.environment}-enquiry-monitoring-sqs-dlq-alert"
  alarm_description   = "Message Pushed to DLQ"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  datapoints_to_alarm = 1

  metric_query = [
    {
      id = "e1"

      return_data = true
      expression  = "m2-m1"
      label       = "ChangeInAmountVisible"
    },
    {
      id = "m1"

      metric = [
        {
          namespace = "AWS/SQS"
          # metric_name = "NumberOfMessagesSent" # For mannual purposes
          metric_name = "ApproximateNumberOfMessagesVisible" # For automatic purposes
          period      = 300                                  # evaluate maximum over period of 5 min
          stat        = "Minimum"
          unit        = "Count"
          return_data = false
          dimensions = {
            QueueName = local.queue_name
          }
        }
      ]
    },
    {
      id = "m2"

      metric = [
        {
          namespace   = "AWS/SQS"
          metric_name = "NumberOfMessagesSent"
          period      = 300 # evaluate maximum over period of 5 min
          stat        = "Maximum"
          unit        = "Count"
          return_data = false
          dimensions = {
            QueueName = local.queue_name
          }
        }
      ]
    }
  ]

  alarm_actions = [dependency.notify_sns_arn.outputs.sns_topic_arn]

}
