#!/bin/bash

if [ -z "$SCRIPT_PARAMS_VARIABLES" ]; then
    SCRIPT_PARAMS_VARIABLES=(STEP)
fi

if [ -z "$SCRIPT_PARAMS_USAGE" ]; then
    SCRIPT_PARAMS_USAGE='<step ex.infrastructure|deployment|provisioning>'
fi

script_params_number="${#SCRIPT_PARAMS_VARIABLES[@]}"

# Check if number of provided parameters is correct
if [[ "$#" < "$script_params_number" ]]; then
    printf 'Error: needs %s parameter(s) - called with %s parameter(s)\n' "$script_params_number" "$#" >&2
    printf 'Usage: %s %s\n' "$(basename "$0")" "$SCRIPT_PARAMS_USAGE" >&2
    exit 1
fi

# Get variables from parameter
for var in "${SCRIPT_PARAMS_VARIABLES[@]}"; do
    export "$var"="${1}"; shift
done

# Export the command options variable
export COMMAND_OPTIONS="$@"
