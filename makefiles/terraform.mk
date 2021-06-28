TF_VERSION?=1.0.0

DOCKER_IMAGE?=hashicorp/terraform

DOCKER_COMMAND?=docker run \
				--rm \
				--volume $(shell pwd):/deployment \
				--volume ${SSH_AUTH_SOCK}:/ssh-agent \
				--volume /etc/passwd:/etc/passwd:ro \
				--workdir /deployment \
				--user "$(shell id -u):$(shell id -g)" \
				--env-file env_template \
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

clean:
	@rm -rf .terraform*

.PHONY: all ssh-config init plan apply clean
