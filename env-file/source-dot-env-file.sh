#!/bin/bash

# Check if the file .env exists, if not it stops the script
# The check is bypassed if we are on Jenkins
if [[ ! -f .env && ! ${JENKINS_HOME} ]]; then
    printf 'Please create the file .env from the template .env_template and by adding your credentials.\n'
    exit 1
fi

# Source the env file if it exists
if [ -f .env ]; then
    source .env
fi
