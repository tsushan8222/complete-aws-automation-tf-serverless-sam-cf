# Secondary DevOps Pipeline
Pipeline provisions codebuild environment reuired for secondary (old) pipleine
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.56.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 4.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.56.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.example](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_webhook.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/codebuild_webhook) | resource |
| [aws_codestarnotifications_notification_rule.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/codestarnotifications_notification_rule) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.policydoc](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Application Name | `string` | n/a | yes |
| <a name="input_application_role"></a> [application\_role](#input\_application\_role) | Role Used for packaging and deploy application | `string` | n/a | yes |
| <a name="input_build_compute_size"></a> [build\_compute\_size](#input\_build\_compute\_size) | Compute size for build environment | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Build environment image | `string` | `"aws/codebuild/standard:5.0"` | no |
| <a name="input_build_script_path"></a> [build\_script\_path](#input\_build\_script\_path) | build script\_path | `string` | n/a | yes |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | Build Timeout in minutes | `number` | `60` | no |
| <a name="input_concurrent_build_limit"></a> [concurrent\_build\_limit](#input\_concurrent\_build\_limit) | No of builds that will run at a time | `number` | `1` | no |
| <a name="input_devops_branch"></a> [devops\_branch](#input\_devops\_branch) | DevOps Branch | `string` | `"develop"` | no |
| <a name="input_devops_git_url"></a> [devops\_git\_url](#input\_devops\_git\_url) | DevOps GitUrl | `string` | `"https://github.com/hlexperts/devops.git"` | no |
| <a name="input_dist_path"></a> [dist\_path](#input\_dist\_path) | path inside repo | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment to which it runs | `string` | `"dev"` | no |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables) | List of pipeline environment variables in format [{ name  = 'role' value = 'codebuild'type  = 'PLAINTEXT' }] | `list(map(string))` | <pre>[<br>  {<br>    "name": "role",<br>    "type": "PLAINTEXT",<br>    "value": "codebuild"<br>  }<br>]</pre> | no |
| <a name="input_git_branch"></a> [git\_branch](#input\_git\_branch) | Git branch on which trigger occurs | `string` | `"develop"` | no |
| <a name="input_git_hub_organization"></a> [git\_hub\_organization](#input\_git\_hub\_organization) | Github Organization Name | `string` | `"hlexperts"` | no |
| <a name="input_git_repo_url"></a> [git\_repo\_url](#input\_git\_repo\_url) | Git repo url in https format | `string` | n/a | yes |
| <a name="input_github_package_org"></a> [github\_package\_org](#input\_github\_package\_org) | Github Package Org | `string` | `"hlexperts"` | no |
| <a name="input_github_pat"></a> [github\_pat](#input\_github\_pat) | Github Personal Access Token | `string` | n/a | yes |
| <a name="input_github_shared_secret"></a> [github\_shared\_secret](#input\_github\_shared\_secret) | Github Shared secret for webhook | `string` | n/a | yes |
| <a name="input_iam_tags"></a> [iam\_tags](#input\_iam\_tags) | Default IAM tags | `map(string)` | <pre>{<br>  "role": "codebuild"<br>}</pre> | no |
| <a name="input_logging_bucket_name"></a> [logging\_bucket\_name](#input\_logging\_bucket\_name) | Logging Bucket name | `string` | n/a | yes |
| <a name="input_multi_branch"></a> [multi\_branch](#input\_multi\_branch) | Supports Multi branch deployment or not | `bool` | `false` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Additional policies statements of structure policies = [{actions = ['kms:*',] resources = ['*'] principals     = [] not\_principals = [] condition      = [] }] | `any` | `[]` | no |
| <a name="input_sns_arn"></a> [sns\_arn](#input\_sns\_arn) | ARN for SNS to which it sends Build Notifications | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional Tags to propagate | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->