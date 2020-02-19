#!/bin/bash

BASEDIR=$(dirname "$(readlink -f -- "$0")")

# If the user provided a custom set of variable and it doesn't contain the STEP variable,
# we throw an error because we need it for Terraform scripts
if [[ -n "$SCRIPT_PARAMS_VARIABLES" && ! "${SCRIPT_PARAMS_VARIABLES[@]}" =~ "STEP" ]]; then
    printf "Error: STEP variable isn't in your \`SCRIPT_PARAMS_VARIABLES\`. It's needed by Terraform scripts\n" >&2
    exit 1
fi

source "$BASEDIR"/bash-methods/components/check-bash-parameters.sh

# When we run a `terraform output` command, we want the script to only display
# the output of terraform, not the logs of the script.
# For this we use fd redirection
if [ "$STEP" = "output" ]; then
    exec 3>&1 1>/dev/null # Save `value` of stdout in file descriptor 3 and redirect stdout to /dev/null
fi
