#!/bin/bash

# Check if GITHUB_CREDS exists
if [ ! ${GITHUB_CREDS} ]; then
    printf 'The variable GITHUB_CREDS does not exist. Impossible to configure GIT.\n' >&2
    exit 1
fi

# Check if the .gitconfig file already exists, if not create it
if [ ! -f ".gitconfig" ]; then
    # Create .gitconfig file
    cat << EOF > ".gitconfig"
[url "https://github.com/"]
    insteadOf = ssh://git@github.com
    insteadOf = git@github.com:
[credential]
    helper = store
EOF
fi

# Check if the .git-credentials file already exists, if not create it
if [ ! -f ".git-credentials" ]; then
    # Create .git-credenatials file
    cat << EOF > ".git-credentials"
https://${GITHUB_CREDS}@github.com
EOF
fi
