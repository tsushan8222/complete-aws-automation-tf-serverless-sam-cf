# Serverless Pipeline
Pipeline provisions codebuild environment reuired for serverless pipleine

## Operation
If required CodeBuild will support multi repo deployment.

**Reserved Environment Variables**
- All AWS CodeBuild Variables
- ARTIFACT_BUCKET_NAME
- LOGGING_BUCKET_NAME
- TERRAFORM_STATE_BUCKET_NAME
- ENV
- DEFAULT_BRANCH
- SERVICE_BASE_PATH

**Reserved Keywords in git branch names**
- refs/heads/
- refs/branch/
- branch/

**Module Operation**

Module will grab Git repository and cleans special chars and creates `REPO_NAME`.

If Git webhook triggers the pipeline it will extrat the branch and compares to `DEFAULT_BRANCH` if branch name is same `DEPLOYMENT_PREFIX` will be empty else `DEPLOYMENT_PREFIX` is genrated from `CODEBUILD_WEBHOOK_TRIGGER` removing special characters trimming to `20` characters.

## Overrides
- DEPLOYMENT_PREFIX 

Using this override we can control the stack name ans AWS resource naming prefixes.

*Using the following Script all exports are genrated*

```bash
          #!/bin/bash
          set -e

          #Required 
          # 1. ENV
          # 1. DEFAULT_BRANCH
          # 1. CODEBUILD_SOURCE_REPO_URL
          # 1. SERVICE_BASE_PATH

          # Exports
          # 1. DEPLOYMENT_PREFIX
          # 1. CFN_STACK_NAME
          # 1. TERRAFORM_STATE_PATH

          # Overrides
          # 1. DEPLOYMENT_PREFIX

          gen_cfn_compatible_branch_name() {
              name=$1
              # Trimes to len 20
              # Removes (. > - | $ > null | / > - | space > null)
              local special_char_trimed=$(echo $name | sed -E "s/branch\///g" | sed -E "s/refs\/heads\/branch\///g" | sed -E "s/refs\/heads\///g"  | sed -E "s/@//g" | sed -E "s/\//-/g" | sed -E "s/[[:space:]]//g" | sed -E "s/\./-/g" | sed -E "s/$//g" | sed -E "s/_/-/g")
              echo $${special_char_trimed::20}
          }

          gen_cfn_compatible_repo_name() {
              name=$1
              # Trimes to len 20
              # Removes (. > - | $ > null | / > - | space > null)
              local special_char_trimed=$(echo $name | sed "s/git@github.com://g" | sed "s/https:\/\/github.com\///g" | sed "s/\//-/g" | sed "s/.git//g"| sed -E "s/refs\/heads\///g"  | sed -E "s/@//g" | sed -E "s/\//-/g" | sed -E "s/[[:space:]]//g" | sed -E "s/\./-/g" | sed -E "s/$//g" | sed -E "s/_/-/g")
              echo $special_char_trimed
          }
          get_alpha_numeric_char(){
            text=$1
            local stripped=$(echo $text | sed -E "s/[^a-zA-Z0-9]//g")
            echo $stripped
          }

          if [[ -z "$ENV" ]]; then
            echo "Deployment Environment is not set"
            return 1
          fi


          if [[ -z "$DEFAULT_BRANCH" ]]; then
            echo "Default branch is not set for evaluating DEPLOYMENT_PREFIX"
            return 1
          fi

          if [[ -z "$SERVICE_BASE_PATH" ]]; then
            echo "SERVICE_BASE_PATH not set"
            return 1
          fi

          if [[ -z "$CODEBUILD_SOURCE_REPO_URL" ]]; then
            echo "Repo URL not set"
            return 1
          fi

          export REPO_NAME=$(gen_cfn_compatible_repo_name $CODEBUILD_SOURCE_REPO_URL )

          TRIGGER_REF=$DEFAULT_BRANCH

          if [[ -n "$CODEBUILD_WEBHOOK_TRIGGER" ]]; then
            TRIGGER_REF=$(echo $CODEBUILD_WEBHOOK_TRIGGER | sed -E "s/branch\///g" | sed -E "s/refs\/heads\///g" | sed -E "s/refs\/heads\/branch\///g" )
          fi
          # Only For CodeBuild and the code dir shouls be navigated before
          if [[ -z "$CODEBUILD_WEBHOOK_TRIGGER" ]]; then
            git checkout $DEFAULT_BRANCH 
          fi

          PREFIX=''

          if [[ "$TRIGGER_REF" != "$DEFAULT_BRANCH" ]]; then
            PREFIX=$(gen_cfn_compatible_branch_name $CODEBUILD_WEBHOOK_TRIGGER ) 
          fi

          if [[ -z "$DEPLOYMENT_PREFIX" ]]; then
              export DEPLOYMENT_PREFIX=$(echo $PREFIX | awk '{print tolower($0)}')
          else
              export DEPLOYMENT_PREFIX=$(echo $DEPLOYMENT_PREFIX | awk '{print tolower($0)}')
          fi

          SERVICE_BASE_PATH_NORM=$(get_alpha_numeric_char $SERVICE_BASE_PATH)

          CFN_STACK_NAME="$ENV-$REPO_NAME-$SERVICE_BASE_PATH_NORM-$DEPLOYMENT_PREFIX"
          TERRAFORM_STATE_PATH="$ENV/$REPO_NAME/$SERVICE_BASE_PATH_NORM/$DEPLOYMENT_PREFIX"

          if ( [[ -z "$SERVICE_BASE_PATH_NORM" ]] && [[ -n "$DEPLOYMENT_PREFIX" ]]); then
            CFN_STACK_NAME="$ENV-$REPO_NAME-$DEPLOYMENT_PREFIX"
            TERRAFORM_STATE_PATH="$ENV/$REPO_NAME/$DEPLOYMENT_PREFIX"
          fi

          if ( [[ -z "$DEPLOYMENT_PREFIX" ]] && [[ -n "$SERVICE_BASE_PATH_NORM" ]] ); then
            CFN_STACK_NAME="$ENV-$REPO_NAME-$SERVICE_BASE_PATH_NORM"
            TERRAFORM_STATE_PATH="$ENV/$REPO_NAME/$SERVICE_BASE_PATH_NORM"
          fi

          if ( [[ -z "$SERVICE_BASE_PATH_NORM" ]] && [[ -z "$DEPLOYMENT_PREFIX" ]]); then
            CFN_STACK_NAME="$ENV-$REPO_NAME"
            TERRAFORM_STATE_PATH="$ENV/$REPO_NAME"
          fi 

          export CFN_STACK_NAME=$(echo $CFN_STACK_NAME | awk '{print tolower($0)}')
          export TERRAFORM_STATE_PATH=$(echo $TERRAFORM_STATE_PATH | awk '{print tolower($0)}')

          #Logs
          echo $CFN_STACK_NAME
          echo $TERRAFORM_STATE_PATH
```
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
| [aws_codestarnotifications_notification_rule.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/codestarnotifications_notification_rule) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_policy_document.policydoc](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Application Name | `string` | n/a | yes |
| <a name="input_artifact_bucket_name"></a> [artifact\_bucket\_name](#input\_artifact\_bucket\_name) | Artifact Bucket name | `string` | n/a | yes |
| <a name="input_build_compute_size"></a> [build\_compute\_size](#input\_build\_compute\_size) | Compute size for build environment | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Build environment image | `string` | `"aws/codebuild/standard:4.0"` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | Build Timeout in minutes | `number` | `60` | no |
| <a name="input_common_trigger_path"></a> [common\_trigger\_path](#input\_common\_trigger\_path) | Repo Common Path that will trigger the build | `string` | `null` | no |
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
| <a name="input_policies"></a> [policies](#input\_policies) | Additional policies statements of structure policies = [{actions = ['kms:*',] resources = ['*'] principals     = [] not\_principals = [] condition      = [] }] | `any` | `[]` | no |
| <a name="input_service_base_path"></a> [service\_base\_path](#input\_service\_base\_path) | Service Base Path relative to project root () | `string` | n/a | yes |
| <a name="input_sns_arn"></a> [sns\_arn](#input\_sns\_arn) | ARN for SNS to which it sends Build Notifications | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional Tags to propagate | `map(string)` | `{}` | no |
| <a name="input_tf_state_bucket_name"></a> [tf\_state\_bucket\_name](#input\_tf\_state\_bucket\_name) | Logging Bucket name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->