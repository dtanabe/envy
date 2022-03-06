# Disable exporting of all environment variables because we're testing profile scripts.
# If we preserve the environment as-is AND someone is running `make test` from within
# an environment bootstrapped by envy, then we'll be calling envy twice!
unexport

# Operate with a much smaller path, again, because envy scripts set the path for us.
PATH=$(dir $(shell which shellspec)):/usr/local/bin:/usr/bin:/bin
export PATH

# We need HOME set for most of the profile scripts tests.
export HOME

# Export REPOS_ROOT so that we know which directory to set up per-repo aliases in.
export REPOS_ROOT

shell_src := \
	.installer/install.sh \
	etc/bash/profile \
	$(shell find etc/bash -name "*.sh" -type f)

shellspec := $(shell which shellspec)

error:
	@echo "Please specify a make target"
	@exit 2

install:
	.installer/install.sh

test:
	shellcheck $(shell_src)
	#shellspec --shell bash
