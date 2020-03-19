#!/bin/bash

# Check if REQUIRED_ENV_VARS is defined
if [ ! ${REQUIRED_ENV_VARS} ]; then
    printf 'The REQUIRED_ENV_VARS environment variable is not defined.\n' >&2
    printf 'Please define it or do not use this script.\n' >&2
    exit 1
fi

# Check each environment variable 
for env_var in "${REQUIRED_ENV_VARS[@]}"
do
    if [ ! -v "${env_var}" ]; then
        printf "ERROR: %s environment variable is not defined and is required.\n" "${env_var}" >&2
        exit 1
    fi
done

printf 'All environments variables are defined.\n'
