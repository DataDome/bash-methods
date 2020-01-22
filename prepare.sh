#!/bin/bash

set -e

BASEDIR=$(dirname "$(readlink -f -- "$0")")
cd "${BASEDIR}" || exit

# Define bash-methods path
export BASH_METHODS_PATH="${BASEDIR}/bash-methods"

if [ -d "${BASH_METHODS_PATH}" ]; then
    printf 'Directory %s exists. Update source of the repository.\n' "${BASH_METHODS_PATH}"
    # Update source of the repository
    cd "${BASH_METHODS_PATH}"
    git pull
    cd "${BASEDIR}"
else
    printf 'Clone source of the repository.\n'
    # Clone bash-methods repo
    git clone https://github.com/DataDome/bash-methods.git "${BASH_METHODS_PATH}"
fi
