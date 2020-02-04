#!/bin/bash

printf 'Launch Terraform script.\n'
docker-compose pull
docker-compose up \
    --build \
    --abort-on-container-exit \
    --exit-code-from terraform \
    terraform
