#!/bin/bash

# Check if REQUIRED_ENV_VARS is defined
if [ ! ${REQUIRED_ENV_VARS} ]; then
    printf 'The REQUIRED_ENV_VARS environment variable is not defined.\n'
    printf 'Please define it or do not use this script.'
    exit 1
fi

# Check each environment variable 
for env_var in "${REQUIRED_ENV_VARS[@]}"
do
    if [ ! -v "${env_var}" ]; then
        echo "ERROR: ${env_var} environment variable is not defined and is required.\n"
        exit 1
    fi
done

printf 'All environments variables are defined.\n'
