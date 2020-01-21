#!/bin/bash

# If the variable does not exists, add a default value
# This variable is the path to the GCP account service credentials file
if [ ! ${SERVICE_ACCOUNT_CREDENTIALS_FILE_PATH} ]; then
    export SERVICE_ACCOUNT_CREDENTIALS_FILE_PATH="${HOME}/.config/gcloud/service_account_credentials.json"
fi
