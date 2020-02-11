#!/bin/bash

docker-compose pull --quiet
printf '\n========================\n# Run Terraform script #\n========================\n\n'
if true 2>/dev/null >&3; then # If the file descriptor 3 is open, we
    exec 1>&3 3>&-            # restore value of stdout and close fd 3
fi

docker-compose run --rm terraform
