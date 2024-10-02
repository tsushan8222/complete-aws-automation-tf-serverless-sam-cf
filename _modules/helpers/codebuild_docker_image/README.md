# CodeBuild Image 
CodeBuild Baseline Image for old DevOps Framework

## Base Image Preparation 

The master branch will sometimes have changes that are still in the process of being released in AWS CodeBuild.  See the latest released versions of the Dockerfiles [here](https://github.com/aws/aws-codebuild-docker-images/releases)

### How to build Docker images

Steps to build Standard 4.0 image

* Run `git clone https://github.com/aws/aws-codebuild-docker-images.git` to download this repository to your local machine
* Run `cd ubuntu/standard/4.0` to change the directory in your local workspace. This is the location of the Standard 4.0 Dockerfile with Ubuntu base.
* Run `docker build -t aws/codebuild/standard:4.0 .` to build Docker image locally

To poke around in the image interactively, build it and run:
`docker run -it --entrypoint sh aws/codebuild/standard:4.0 -c bash`

To let the Docker daemon start up in the container, build it and run:
`docker run -it --privileged aws/codebuild/standard:4.0 bash`

```bash
$ git clone https://github.com/aws/aws-codebuild-docker-images.git
$ cd aws-codebuild-docker-images
$ cd ubuntu/standard/4.0
$ docker build -t aws/codebuild/standard:4.0 .
$ docker run -it --entrypoint sh aws/codebuild/standard:4.0 -c bash
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [null_resource.docker](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [template_file.docker](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"ap-southeast-2"` | no |
| <a name="input_docker_image_name"></a> [docker\_image\_name](#input\_docker\_image\_name) | Docker Image name | `string` | `"codebuild-image"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment to which it runs | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_docker_repository_arn"></a> [docker\_repository\_arn](#output\_docker\_repository\_arn) | AWS CodeBuild Docker Repository ARN |
| <a name="output_docker_repository_id"></a> [docker\_repository\_id](#output\_docker\_repository\_id) | AWS CodeBuild Docker Repository ID |
| <a name="output_docker_repository_url"></a> [docker\_repository\_url](#output\_docker\_repository\_url) | AWS CodeBuild Docker Repository URL |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->