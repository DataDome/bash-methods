export USERID=$(shell id -u)
export GROUPID=$(shell id -g)

# Directory where ansible-galaxy should install roles
ROLES_PATH?=./roles

# List of ansible-galaxy requirement filesm space separated
REQUIREMENTS_FILES?=./ansible-role-base/requirements.yml

# Ansible playbook file to launch
PLAYBOOK_FILE?=./playbook.yml

all: install-roles check

ssh-config:
ifndef SSH_AUTH_SOCK
	$(error Please load ssh-agent)
endif

install-roles: ssh-config
	@docker-compose run --rm ansible ansible-galaxy install --force --roles-path $(ROLES_PATH) -r $(REQUIREMENTS_FILES)

check: ssh-config
	@docker-compose run --rm ansible ansible-playbook --diff --check ${o} $(PLAYBOOK_FILE)

apply: ssh-config
	@printf "\e[1;34mAnsible will apply changes, please don't forget to run your playbook in check mode.\nAre you sure you want to continue? [y/n]: \e[0m" && read ans && [ $${ans:-N} = y ]
	@docker-compose run --rm ansible ansible-playbook --diff ${o} $(PLAYBOOK_FILE)

.PHONY: all ssh-config install-roles check apply
