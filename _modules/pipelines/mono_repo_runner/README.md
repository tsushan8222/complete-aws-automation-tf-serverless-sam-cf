# Serverless MonoRepo Runner
Deployes mono repo services

## Operation

**Reserved Environment Variables**
- All AWS CodeBuild Variables
- DEPLOY_ALL (default = 0 )
- IS_MODE_QUEUED (default = 1 )
- COMMON_CODE_PATH (default = "libs" )
- SERVICES_PATH (default = "services" )
- SERVICE_MAPPING_CODEBUILD_PROJECT (default = "" ) jsonencoded service with codebuild env and priority
- LOGGING_BUCKET_NAME
- TERRAFORM_STATE_BUCKET_NAME
- ENV
- DEFAULT_BRANCH

**How does the deployment work?**
- If `DEPLOY_ALL` is true we deploy all services
- If `IS_MODE_QUEUED` we wait for the current deployment to complete
- We get all the services name that had changed between the commits
- If `COMMON_CODE_PATH` has changes we mark `DEPLOY_ALL` as true
- `SERVICE_MAPPING_CODEBUILD_PROJECT` we unpack this which has structure
```json
{
  "services": [
    {
      "service_name": "opportunity-api",
      "code_build_project_name": "dev-workbench_opportunity_api-codebuild",
      "priority": 10
    },
    {
      "service_name": "opportunity-sam",
      "code_build_project_name": "dev-workbench_opportunity_sam-codebuild",
      "priority": 1
    }
  ]
}
```
- Now we sort the json by `priority`
- Now for all `services` we check if the service is in `changed-services`
- If so, we deploy

**Script**
```bash
#!/bin/bash

set -e

#Test Variables
CODEBUILD_PROJECT_SERVICE_MAPPING='{"services":[{"code_build_project_name":"dev-workbench_opportunity_api-codebuild","priority":10,"service_name":"opportunity-api"}]}'

function elementExists() {
    element=${1}
    shift
    elements=("$@") 
    in_array=0
    for i in ${elements[@]} ; do
        if [[ $i == $element ]] ; then
            in_array=1
            break
        fi
    done
    echo $in_array
}

function getSubDirAsArray(){
    path=${1}
    local arr=()
    for dir in $(find $path -maxdepth 1 -type d -exec realpath --relative-to $path {} \;)
    do
        if [[ ! (($dir == ".") || ($dir == "./") || ($dir == "..")) ]]; then
            arr=("${arr[@]}" "${dir}") 
        fi
    done 
    echo ${arr[@]} 
}
function error_exit()
{
    echo "$1" 1>&2
    exit 1
}

function runCodeBuildWithWait(){
    CODEBUILD_PROJECT_NAME=$1

    echo "Starting CodeBuild project. Project name is ${CODEBUILD_PROJECT_NAME}."

    START_RESULT=`aws codebuild start-build --project-name ${CODEBUILD_PROJECT_NAME}`
    if [ "$?" != "0" ]; then
        error_exit "Could not start CodeBuild project. Exiting."
    else
        echo "Build started successfully."
    fi

    BUILD_ID=`echo ${START_RESULT} | jq '.build.id' -r`

    BUILD_STATUS="IN_PROGRESS"
    while [ "$BUILD_STATUS" == "IN_PROGRESS" ]; do
        sleep 10
        echo "Checking build status."
        BUILD=`aws codebuild batch-get-builds --ids ${BUILD_ID}`
        BUILD_STATUS=`echo $BUILD | jq '.builds[0].buildStatus' -r`
        if [ "$BUILD_STATUS" == "IN_PROGRESS" ]; then
            echo "Build is still in progress, waiting..."
        fi
    done

    if [ "$BUILD_STATUS" != "SUCCEEDED" ]; then
        LOG_URL=`echo $BUILD | jq '.builds[0].logs.deepLink' -r`
        error_exit "Build failed, please review job output. Logs are available at $LOG_URL."
    else
        echo "Build succeeded."
    fi
}

function runCodeBuildWithOutWait(){
    CODEBUILD_PROJECT_NAME=$1

    echo "Starting CodeBuild project. Project name is ${CODEBUILD_PROJECT_NAME}."

    START_RESULT=`aws codebuild start-build --project-name ${CODEBUILD_PROJECT_NAME}`
    if [ "$?" != "0" ]; then
        error_exit "Could not start CodeBuild project. Exiting."
    else
        echo "Build started successfully."
    fi

    BUILD_ID=`echo ${START_RESULT} | jq '.build.id' -r`

}
# check if necessary commands are available
command -v git > /dev/null 2>&1 || { echo "Git not installed."; exit 1; }
command -v jq > /dev/null 2>&1 || { echo "jq not installed."; exit 1; }


# Get Current abbreviated branch name
branch=`git rev-parse --abbrev-ref HEAD` #set default stage
echo -e "selected branch $branch"

# Retrieve the modified files, excluding the merge commit between last two commits
merge_commit_hash=`git rev-parse --short HEAD`
build_commit_hash=`git rev-list --no-merges -n1 HEAD`

files="$(git diff-tree --no-commit-id --name-only -r $build_commit_hash)"
echo $files

# Retrive from codebuild
deploy_all=${DEPLOY_ALL:-0}
is_mode_queued=${IS_MODE_QUEUED:-1}
common_code_path=${COMMON_CODE_PATH:-"libs"}
services_path=${SERVICES_PATH:-"services"}
codebuild_with_service_mapping=${SERVICE_MAPPING_CODEBUILD_PROJECT:-""}
####

all_services=()
changed_services=()

if [[ -z "$codebuild_with_service_mapping" ]]; then
    exit 1
fi

for file in $files; do
    if [[ $file == "$common_code_path"* ]]; then
        deploy_all=1
        break
    elif [[ $file == $services_path* ]]; then
        service_changed="$(echo $file | cut -d '/' -f2)"
        does_service_exist=$(elementExists $service_changed ${changed_services[@]})
        if [[ $does_service_exist != 1 ]]; then
            changed_services=("${changed_services[@]}" "$service_changed") 
        fi
    fi
done

all_services="$(getSubDirAsArray $services_path)"

if [[ "$deploy_all" == 1 ]]; then
    changed_services=${all_services[@]}
fi
echo "Changed Sevices ${changed_services[@]}"
echo "All Sevices ${all_services[@]}"

services_sorted_by_priority=$(echo $codebuild_with_service_mapping | jq '.services |=(sort_by(.priority) | reverse | unique_by(.service_name))')


for index in $(jq '.services | keys | .[]' <<< "$services_sorted_by_priority"); do
    value=$(jq -r ".services[$index]" <<< "$services_sorted_by_priority");
    s_name=$(jq -r '.service_name' <<< "$value");
    cb_project_name=$(jq -r '.code_build_project_name' <<< "$value");
    check_if_project=$(elementExists $s_name ${changed_services[@]})
    if [[ $check_if_project == 1 ]]; then
            if [[ $is_mode_queued == 1 ]]; then
                runCodeBuildWithWait $cb_project_name
                echo "Deploying .. $cb_project_name"
            else
                runCodeBuildWithOutWait $cb_project_name
                echo "Deploying .. $cb_project_name"
            fi
    fi
done
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
| [aws_codebuild_webhook.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/codebuild_webhook) | resource |
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
| <a name="input_common_folder_path"></a> [common\_folder\_path](#input\_common\_folder\_path) | Service path directory name | `string` | `"libs"` | no |
| <a name="input_deploy_all"></a> [deploy\_all](#input\_deploy\_all) | Deploy all or not regardless of changes | `number` | `0` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment to which it runs | `string` | `"dev"` | no |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables) | List of pipeline environment variables in format [{ name  = 'role' value = 'codebuild'type  = 'PLAINTEXT' }] | `list(map(string))` | <pre>[<br>  {<br>    "name": "role",<br>    "type": "PLAINTEXT",<br>    "value": "codebuild"<br>  }<br>]</pre> | no |
| <a name="input_git_branch"></a> [git\_branch](#input\_git\_branch) | Git branch on which trigger occurs | `string` | `"develop"` | no |
| <a name="input_git_hub_organization"></a> [git\_hub\_organization](#input\_git\_hub\_organization) | Github Organization Name | `string` | `"hlexperts"` | no |
| <a name="input_git_repo_url"></a> [git\_repo\_url](#input\_git\_repo\_url) | Git repo url in https format | `string` | n/a | yes |
| <a name="input_github_package_org"></a> [github\_package\_org](#input\_github\_package\_org) | Github Package Org | `string` | `"hlexperts"` | no |
| <a name="input_github_pat"></a> [github\_pat](#input\_github\_pat) | Github Personal Access Token | `string` | n/a | yes |
| <a name="input_github_shared_secret"></a> [github\_shared\_secret](#input\_github\_shared\_secret) | Github Shared secret for webhook | `string` | n/a | yes |
| <a name="input_iam_tags"></a> [iam\_tags](#input\_iam\_tags) | Default IAM tags | `map(string)` | <pre>{<br>  "role": "codebuild"<br>}</pre> | no |
| <a name="input_is_mode_queued"></a> [is\_mode\_queued](#input\_is\_mode\_queued) | If codebuild should wait for deployment to complete | `number` | `1` | no |
| <a name="input_logging_bucket_name"></a> [logging\_bucket\_name](#input\_logging\_bucket\_name) | Logging Bucket name | `string` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | Additional policies statements of structure policies = [{actions = ['kms:*',] resources = ['*'] principals     = [] not\_principals = [] condition      = [] }] | `any` | `[]` | no |
| <a name="input_service_mapping_code_build"></a> [service\_mapping\_code\_build](#input\_service\_mapping\_code\_build) | json encoded string of service to codebuild mapping | `string` | n/a | yes |
| <a name="input_services_path"></a> [services\_path](#input\_services\_path) | Service path directory name | `string` | `"services"` | no |
| <a name="input_sns_arn"></a> [sns\_arn](#input\_sns\_arn) | ARN for SNS to which it sends Build Notifications | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional Tags to propagate | `map(string)` | `{}` | no |
| <a name="input_tf_state_bucket_name"></a> [tf\_state\_bucket\_name](#input\_tf\_state\_bucket\_name) | Logging Bucket name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->