#!/usr/bin/env bash

if ! which ssh-agent; then
    printf 'Please install ssh-agent.\n' >&2 
    exit 1
fi

# Check if SSH_KEY_PATH exists, if not, add a default value
if [ ! "$SSH_KEY_PATH" ]; then
    SSH_KEY_PATH="${HOME}/.ssh/keys/jenkinsdeploy.pem"
fi

# Check if the file exists, if not, ask a new path
while [ ! -f "$SSH_KEY_PATH" ]; do
    printf "No such file: %s\nPlease write the path of your jenkinsdeploy.pem file\n" "${SSH_KEY_PATH}"
    read -p '> ' SSH_KEY_PATH
done

printf 'Adding %s key to ssh agent...\n' "${SSH_KEY_PATH}"
eval $(ssh-agent)
ssh-add "${SSH_KEY_PATH}"
printf "\e[32m[OK] Key added to SSH agent\e[0m\n"
