#!/bin/bash

# Check if number of parameter is correct
if [[ $# -lt 1 ]] ; then
    printf 'Error: needs at least 1 parameter(s) - called with %s parameter(s)\n' "$#"
    printf 'Usage: %s <command ex.init|plan|apply>\n' "$(basename "$0")"
    exit 1
fi

# Get the first argument as the terraform step that will be launched
export STEP=$1; shift
# Get all other command options
# We use it to add other arguments to terraform commands
export COMMAND_OPTIONS="$@"
