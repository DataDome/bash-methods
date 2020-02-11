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

# When we run a `terraform output` command, we want the script to only display
# the output of terraform, not the logs of the script.
# For this we use fd redirection
if [ "$STEP" = "output" ]; then
    exec 3>&1 1>/dev/null # Save `value` of stdout in file descriptor 3 and redirect stdout to /dev/null
fi
