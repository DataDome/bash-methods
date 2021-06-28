all: git-submodule

git-submodule:
	@git submodule init
	@git submodule update --remote --force

.PHONY: all git-submodule
