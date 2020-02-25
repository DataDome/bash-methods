#!/bin/bash

# Check if GITHUB_CREDS exists
if [ ! ${GITHUB_CREDS} ]; then
    printf 'The variable GITHUB_CREDS does not exist. Impossible to configure GIT.\n'
    exit 1
fi

# Create a tmp directory to store the git credential socket
tmp_dir=$(mktemp -dt git-XXXXXXXXXXXX)

# Configure the credentials in the cache git credential helper, see https://git-scm.com/docs/git-credential-cache
printf "url=https://github.com\nusername=%s\npassword=%s\n\n" "${GITHUB_CREDS%:*}" "${GITHUB_CREDS#*:}" | \
git -c credential.helper="cache --socket ${tmp_dir}/agent --timeout 900" credential approve

# Ensure permissions are not too open
chmod -R 0700 $tmp_dir

export GIT_AUTH_SOCK="${tmp_dir}/agent"

# Create .gitconfig file
cat << EOF > ".gitconfig"
[url "https://github.com/"]
    insteadOf = ssh://git@github.com
    insteadOf = git@github.com:
[credential]
    helper = "cache --socket /git-agent"
EOF
