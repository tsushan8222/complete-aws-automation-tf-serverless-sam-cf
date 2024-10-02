# HLE-Terragrunt ( DevOps Solution )

## Installation

### Terragrunt

**Windows:** You can install Terragrunt on Windows using Chocolatey: choco install terragrunt.

**macOS:** You can install Terragrunt on macOS using Homebrew: brew install terragrunt.

**Linux:** Most Linux users can use Homebrew: brew install terragrunt. Arch Linux users can either use the pre-built binaries from aur/terragrunt-bin or build Terragrunt from source from aur/terragrunt.

### Terraform

**Windows**: `choco install terraform`

**Linux**:

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt install terraform==0.14.5
```

### Usage:

##### Applying on all resources on sub-folder

**Plan**

```
cd env/dev
terragrunt plan-all
```

**Apply**

```
cd env/dev
terragrunt apply-all
```

##### Applying on specific file

**Plan**

```
cd env/dev
terragrunt plan
```

**Apply**

```
cd env/dev
terragrunt apply
```

## Running Hooks before publishing

**Install required binaries**

_MAC_

```bash
brew tap liamg/tfsec
brew install pre-commit gawk terraform-docs tflint tfsec coreutils
```

_Linux_

```bash
sudo apt install python3-pip gawk &&\
pip3 install pre-commit
curl -L "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E "https://.+?-linux-amd64")" > terraform-docs && chmod +x terraform-docs && sudo mv terraform-docs /usr/bin/
curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip && unzip tflint.zip && rm tflint.zip && sudo mv tflint /usr/bin/
env GO111MODULE=on go get -u github.com/liamg/tfsec/cmd/tfsec
```

### Generating Docs for modules

- Create README.md file at module folder level
- Insert the block

  `<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->`
  `<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->`

- It will generate a README.md with all variable with input types, defaults , descriptions
- Usage can be added by individual.

## Running Commit Before Pushing

_From root folder_

```bash
pre-commit run -a
```

## Install Brew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Secret Management with SOPS

**Install SOPS**

`brew install sops`

**Usage**

For every env navigate to `env`
Encryption:

```bash
sops <env>/../<file_name.<env>.yaml>
eg: sops dev/service/secrets.dev.yaml
```

Decryption:

```bash
sops <file_path>
eg: dev/service/secrets.dev.yaml>
```

Reference: https://github.com/mozilla/sops


### Keybase Installization 

*** linux  ***

https://keybase.io/docs/the_app/install_linux

Keybase allows users to easily encrypt, decrypt and share messages within a tried-and-tested encryption standard. 
It offers an cloud storage system for PGP key which is use for decryption and also can use for multiple team member.
PGP key need to be generated before encryption and decryption.

'''bash
### create account on keybase.io
keybase signup 
### Login on local machine  
keybase login

### Generate public key

keybase pgp gen

*** windows *** 
https://keybase.io/docs/the_app/install_windows

- Download the exe file and install
- Signup on keybase.io
- Login on local machine 
- Generate public Key

*** mac os ***

https://keybase.io/docs/the_app/install_macos

- Download the Keybase.dmg and install
- Signup on keybase.io
- Login on local machine 
- Generate public Key