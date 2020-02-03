#!/bin/bash

set -e

# Define bash-methods path
export BASH_METHODS_PATH="./bash-methods"

if [ -d "${BASH_METHODS_PATH}" ]; then
    printf 'Directory %s exists. Update DataDome bash-methods repository source.\n' "${BASH_METHODS_PATH}"
    # Update source of the repository
    cd "${BASH_METHODS_PATH}"
    git pull > /dev/null
    cd ..
else
    printf 'Clone DataDome bash-methods repository.\n'
    # Clone bash-methods repo
    git clone https://github.com/DataDome/bash-methods.git "${BASH_METHODS_PATH}" > /dev/null
fi
