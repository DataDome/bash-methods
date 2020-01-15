#!/bin/bash

# Check if number of parameter is correct
if [[ $# -lt 1 ]] ; then
    printf 'Error: needs 1 parameter(s) - called with %s parameter(s)\n' "$#"
    printf 'Usage: %s <step ex.infrastructure|deployment|provisioning>\n' "$(basename "$0")"
    exit 1
fi

# Get step from parameter
export STEP="${1}"

# Exit if the step does not exist
if [ ! -d "${STEP}" ]; then
    printf 'The step %s does not exist.\n' "${STEP}"
    exit 0
fi
