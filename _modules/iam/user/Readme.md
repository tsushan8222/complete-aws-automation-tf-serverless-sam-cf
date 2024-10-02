This modules create the user in the central account. And also add the particular user to the groups.

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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.group](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_login_profile.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_user_login_profile) | resource |
| [aws_iam_user_policy.default](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.this](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/resources/iam_user_policy) | resource |
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_iam_policy_document.policydoc](https://registry.terraform.io/providers/hashicorp/aws/3.56.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bcc"></a> [bcc](#input\_bcc) | BCC email | `string` | `"devops@homeloanexperts.com.au"` | no |
| <a name="input_iam_groups"></a> [iam\_groups](#input\_iam\_groups) | List of IAM Groups name which will be attached to the IAM user | `list(string)` | `[]` | no |
| <a name="input_keybase_pgp_key"></a> [keybase\_pgp\_key](#input\_keybase\_pgp\_key) | Pass keybase PGP key for decryption | `string` | n/a | yes |
| <a name="input_managed_policies"></a> [managed\_policies](#input\_managed\_policies) | List of managed policies that will be added to individual IAM user | `list(string)` | `[]` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Additional policies statements of structure policies = [{actions = ['kms:*',] resources = ['*'] principals     = [] not\_principals = [] condition      = [] }] | `any` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_sender_email"></a> [sender\_email](#input\_sender\_email) | AWS SES verified sender email address | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | IAM user account | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_password"></a> [password](#output\_password) | Password of the created AWS user account |
| <a name="output_user_arn"></a> [user\_arn](#output\_user\_arn) | Output of created AWS user account arn |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->