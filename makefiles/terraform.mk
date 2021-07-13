TF_VERSION?=1.0.0

SSH_KNOWN_HOSTS_FILE?=${HOME}/.ssh/known_hosts

DOCKER_IMAGE?=hashicorp/terraform

DOCKER_COMMAND?=docker run \
				--rm \
				--volume $(shell pwd):/deployment \
				--volume ${SSH_AUTH_SOCK}:/ssh-agent \
				--volume ${SSH_KNOWN_HOSTS_FILE}:/etc/ssh/ssh_known_hosts:ro \
				--volume /etc/passwd:/etc/passwd:ro \
				--workdir /deployment \
				--user "$(shell id -u):$(shell id -g)" \
				--env HOME=/deployment \
				--env SSH_AUTH_SOCK=/ssh-agent \
				${DOCKER_OPTIONS} \
				${DOCKER_IMAGE}:${TF_VERSION}

all: init plan

ssh-config:
ifndef SSH_AUTH_SOCK
	$(error Please load ssh-agent)
endif

init: ssh-config
	@${DOCKER_COMMAND} init

plan:
	@${DOCKER_COMMAND} plan -out .terraformplan

apply:
	@printf "\e[1;34mTerraform will apply your last plan\nAre you sure you want to continue? [y/n]: \e[0m" && read ans && [ $${ans:-N} = y ]
	@${DOCKER_COMMAND} apply .terraformplan

shell:
	$(eval DOCKER_OPTIONS+=--interactive --tty --env HISTFILE=/dev/null --entrypoint /bin/sh)
	@${DOCKER_COMMAND}

clean:
	@find . -name '.terraform*' -not -name '.terraform.lock.hcl' -exec rm -rf {} +

.PHONY: all ssh-config init plan apply shell clean
