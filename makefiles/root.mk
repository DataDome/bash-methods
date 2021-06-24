all: git-submodule

git-submodule:
	@git submodule init
	@git submodule update

.PHONY: all git-submodule
