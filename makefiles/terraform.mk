export USERID=$(shell id -u)
export GROUPID=$(shell id -g)

all: init plan

ssh-config:
ifndef SSH_AUTH_SOCK
	$(error Please load ssh-agent)
endif

init: ssh-config
	@docker-compose run --rm terraform init

plan:
	@docker-compose run --rm terraform plan -out .terraformplan

apply:
	@printf "\e[1;34mTerraform will apply your last plan\nAre you sure you want to continue? [y/n]: \e[0m" && read ans && [ $${ans:-N} = y ]
	@docker-compose run --rm terraform apply .terraformplan

clean:
	@rm -rf .terraform*

.PHONY: all ssh-config init plan apply clean
