# BASH Methods

This repository contains some useful BASH methods. We use them at DataDome (https://datadome.co) to:
* Reduce code duplication of BASH scripts.
* Have a single source of truth.
* Publish a library to solve recurrent problematics.

We made it as a library to share it with the community. We don't use BASH functions because we wanted to design them as a call to a library and not as a function.

## Usage

To use methods in your Bash script, use this command to clone the repository:

```bash
# Get bash methods repository
bash <(curl -s https://raw.githubusercontent.com/DataDome/bash-methods/master/prepare.sh)
```

After that, you just need to `source` methods in your script to execute them.

## Google cloud Platform

At DataDome, we use Google Cloud Platform (https://cloud.google.com/) to host our applications. 

### GCloud credentials setup

To communicate with the GCP API, we need the credential file provided at the creation of a service account on the interface. So we use the enviromnent variable `SERVICE_ACCOUNT_CREDENTIALS_FILE_PATH` to provide the path of this file (as explained on this documentation https://cloud.google.com/docs/authentication/getting-started)

The script `gcloud/get-credentials-file-path.sh` permits to check if the environment variable `SERVICE_ACCOUNT_CREDENTIALS_FILE_PATH` is setup. If it is not the case, it creates it with the default value `${HOME}/.config/gcloud/service_account_credentials.json`.

It permits to setup this environment variable on our Jenkins pipelines with the path of the file but without setup it on our machines thanks to the default value.

* Requirements

No requirements.

* Usage

```
# GCloud credentials setup
source ./bash-methods/gcloud/get-credentials-file-path.sh
```

## Git

### Configure Git credentials

If you use private Github repositories, when a machine (a Jenkins agent for example) wants to clone them, these agents have to setup Github credentials. It is sometimes very tricky to setup them correctly.

The `git/configure-git.sh` script permits to create a Git configuration based on a login/password passed in environment variable.

`.git-credentials` and `.gitconfig` files will be created by calling this script. By sharing these files, you will be able to access to all your private Github repositories everywhere (between hosts and Docker containers for example).

* Requirements

The environment variable `GITHUB_CREDS` needs to be setup by following this format `username:token`. It is the pair of a user and its token to connect to private Github repositories.

We advise you to use a Github service account and to create the token on this account.

* Usage

```
# Configure Git credentials
source ./bash-methods/git/configure-git.sh
```

## SSH agents

If you use ephemeral machines to make actions on other machines by SSH (Like with Ansible). These new machines does not have any access by default and they need to setup a SSH config before being able to connect to another host. You can share a SSH agent to solve this problem (https://www.ssh.com/ssh/agent).

### Create SSH agent

The script `ssh-agent/create-ssh-agent.sh` permits to create a SSH agent from a SSH private key to share it to any containers or processes to connect to a SSH server without creating new SSH keys.

It is very secured because the access is ephemeral. Of course, the private SSH key needs to be stored in a safe place.

* Requirements

You can either create the file `${HOME}/.ssh/keys/jenkinsdeploy.pem` on your machine or use the environment variable `SSH_KEY_PATH` to overwrite the path of this key.

* Usage

```
# Create SSH agent
source ./bash-methods/ssh-agent/create-ssh-agent.sh
```

## .env file management

Using environment variables for secrets on our machines is very annoying when we begin to use more than 2. To solve that, you can create a file `.env` on your repository to store these secrets and source it in your script to create the environments variables. **Do not forget to add the `.env` file in your `.gitignore` to not store credentials on Git**.

You can use the file `.env_template` to put an example of environment variables you need.

### Source .env file

The script `env-file/source-dot-env-file.sh` permits to check if the file `.env` exists and source it. This file is a git-ignored file where we can setup credentials. To use this method correctly, you need to launch it in the same directory as the file `.env` is expected.

* Requirements

Create the file `.env_template` with all environment variables that need to be setting up without values. This file needs to be committed to be shared.

Example:
```
# AWS credentials
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

# Github credentials
GITHUB_CREDS=
```
And after that, create the `.env` file with secret values.

* Usage

```
# Source .env file
source ./bash-methods/env-file/source-dot-env-file.sh
```

## Get BASH script parameters

You can use the script `components/check-bash-parameters.sh` to parse scripts arguments. By default it will wait 1 argument and export it as `STEP` variable.
All the others arguments are exported as `COMMAND_OPTIONS`.
If you want to customize which parameters you want, you can export theses 2 variables:
- `SCRIPT_PARAMS_VARIABLES`: A bash array containing variables names you want to export (ex: `export SCRIPT_PARAMS_VARIABLES=(PROVIDER REGION STEP)`).
- `SCRIPT_PARAMS_USAGE`: The corresponding usage

* Requirements

There is no specific requirements for this method.

* Usage

```
# Check script parameters
source ./bash-methods/components/check-bash-parameters.sh
```

or

```
# Check custom script parameters
export SCRIPT_PARAMS_VARIABLES=(PROVIDER REGION STEP)
export SCRIPT_PARAMS_USAGE='<provider> <region> <step ex.init|plan|apply>'
source ./bash-methods/components/check-bash-parameters.sh
```

## Terraform

As we use Terraform to deploy our infrastructure. Our BASH deployment scripts are almost all the same. We use BASH script before launching Terraform command to wrap the Terraform command and to modify configuration.
We advise you to use both `terraform/get-script-parameters.sh` and `terraform/run-docker-compose-with-exit-code.sh` in the same script because 

### Get parameters for Terraform script

You can use the script `terraform/get-script-parameters.sh`, it does the same as the `components/check-bash-parameters.sh` script, but you must have a `STEP` variable in your list.
It will clean all script logs from stdout if the step that you want to do is an `output`. It does that by redirecting stdout to `/dev/null` before the script can print anything. Then when you will launch the Terraform container with `terraform/run-docker-compose-with-exit-code.sh`, it will reactivate stdout to print the output.
This permits to parse the output of Terraform in scripts without all the script logs poluate stdout.

* Requirements

If you use custom parameters for your bash script, you must have a `STEP` parameters in your list.

* Usage

```
# Check Terraform parameters
source ./bash-methods/terraform/get-script-parameters.sh
```

### Launch Docker Compose and get exit code

If, like us at DataDome, you use to launch Terraform in a Docker container to easily manage versions and isolate your processes, the method `terraform/run-docker-compose-with-exit-code.sh` will permit you to launch your `docker-compose.yml` with the service `terraform`.

This method will exit your script with the status code of your Terraform command launched in the Docker container.

* Requirements

Your need a `docker-compose.yml` in the same directory as your BASH script.

For example:
```
version: "3.7"

services:
  terraform:
    image: hashicorp/terraform:${TERRAFORM_VERSION}
    working_dir: /deployment
    volumes:
      - ./:/deployment
    # Overwrite 'terraform' entrypoint by nothing
    entrypoint: ''
    # Define the new command to be more flexible
    command: sh -c "terraform ${STEP} ${COMMAND_OPTIONS}"
```

And your Docker service should be named `terraform`.

* Usage

```
# Check terraform script parameters
source ./bash-methods/terraform/run-docker-compose-with-exit-code.sh
```

## Contribution

To contribute to the repository, you can fork it and create a PR from your fork.

If you have any ideas of improvement, you can also open an issue and it will be a pleasure to talk about it.
