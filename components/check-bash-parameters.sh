#!/bin/bash

if [ -z "$SCRIPT_PARAMS_NUMBER" ]; then
    SCRIPT_PARAMS_NUMBER=1
fi

if [ -z "$SCRIPT_PARAMS_VARIABLES" ]; then
    SCRIPT_PARAMS_VARIABLES=(STEP)
fi

if [ -z "$SCRIPT_PARAMS_USAGE" ]; then
    SCRIPT_PARAMS_USAGE='<step ex.infrastructure|deployment|provisioning>'
fi

# Ensure that the array of varibales name is the same as the number of parameters
if [ "${#SCRIPT_PARAMS_VARIABLES[@]}" != "$SCRIPT_PARAMS_NUMBER" ]; then
    printf 'Error: length of `SCRIPT_PARAMS_VARIABLES` array is not the same as `SCRIPT_PARAMS_NUMBER`\n' >&2
    exit 1
fi

# Check if number of provided parameters is correct
if [[ "$#" < "$SCRIPT_PARAMS_NUMBER" ]]; then
    printf 'Error: needs %s parameter(s) - called with %s parameter(s)\n' "$SCRIPT_PARAMS_NUMBER" "$#" >&2
    printf 'Usage: %s %s\n' "$(basename "$0")" "$SCRIPT_PARAMS_USAGE" >&2
    exit 1
fi

# Get variables from parameter
for var in "${SCRIPT_PARAMS_VARIABLES[@]}"; do
    export "$var"="${1}"; shift
done

# Export the command options variable
export COMMAND_OPTIONS="$@"
