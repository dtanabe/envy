#!/bin/sh
# vim: noet
set -eu

_error() {
	echo
	echo "$@" 1>&2
	exit 1
}

PLATFORM=${PLATFORM:-$(uname -s 2>/dev/null ||:)}
REPOS_ROOT=${REPOS_ROOT:-}
ENVY_GIT_HOST=${GIT_HOST:-pb.github.com}
ENVY_ROOT=${ENVY_ROOT:-}

################################################################################
# prerequisites

echo "Checking prerequisites..."
if [ -z "${HOME}" ]; then
	_error "Could not determine \$HOME"
fi
if ! command -v ssh >/dev/null 2>&1; then
	_error "ssh could not be found"
fi
if ! command -v git >/dev/null 2>&1; then
	_error "git could not be found"
fi

[ -f "$HOME/.ssh/config" ] || _error "no ssh config file"

grep "${ENVY_GIT_HOST}" "$HOME/.ssh/config" >/dev/null || _error ".ssh/config: missing config entry for ${ENVY_GIT_HOST}"

if ssh -nqT "git@${ENVY_GIT_HOST}" 2>/dev/null; [ $? -eq 255 ]; then
	_error "No SSH/git config for ${ENVY_GIT_HOST}"
fi
echo " GOOD"


################################################################################
# interactive confirmations


################################################################################
# defaults

# REPOS_ROOT is the default place where all things get checked out. We override
# it in tests, but we generally default it when running normally.
if [ -z "${REPOS_ROOT}" ]; then
	if [ "${PLATFORM}" = "Darwin" ]; then
		REPOS_ROOT="${HOME}/Repositories"
	else
		REPOS_ROOT="${HOME}/repos"
	fi
fi

if [ -z "${ENVY_ROOT}" ]; then
	ENVY_ROOT="${REPOS_ROOT}/pb-envy"
fi

################################################################################
# standard files

envy_files() {
	ret=0

	if ! "_envy_file_$1" "${HOME}/.bashrc" <<-EOF
	export REPOS_ROOT="${REPOS_ROOT}"

	[ -f ~/.bashrc.local ] && . ~/.bashrc.local

	. "${ENVY_ROOT}/etc/bash/profile"
	EOF
	then ret=$((ret + 1)); fi

	if ! "_envy_file_$1" "${HOME}/.bash_profile" <<-EOF
	[ -f ~/.bashrc ] && . ~/.bashrc
	EOF
	then ret=$((ret + 1)); fi

	if ! "_envy_file_$1" "${HOME}/.gitconfig" <<-EOF
	[core]
	    excludesFile = ${ENVY_ROOT}/etc/git/gitignore_global

	[include]
	    path = ${ENVY_ROOT}/etc/git/gitconfig
	EOF
	then ret=$((ret + 1)); fi

	if ! "_envy_file_$1" "${HOME}/.vimrc" <<-EOF
	source ${ENVY_ROOT}/etc/vim/vimrc
	EOF
	then ret=$((ret + 1)); fi

	return $ret
}

_envy_file_verify() {
	if [ -L "${1}" ]; then
		echo "${1} is a symlink"
		return 1
	elif [ -d "${1}" ]; then
		echo "${1} is a directory"
		return 1
	elif [ -f "${1}" ]; then
		git --no-pager diff --exit-code --no-index --no-ext-diff --src-prefix="/" --dst-prefix="" --relative="${HOME}" "${1}" -
	fi
}

_envy_file_write() {
	rm "${1}"
	cat > "${1}"	
}

################################################################################
#

if [ -d "${ENVY_ROOT}/.git" ]; then
	echo "Looks like envy is already checked out at ${ENVY_ROOT}"
else
	echo "Checking out envy..."
	mkdir -p "$(dirname "${ENVY_ROOT}")"
	git clone "git@${ENVY_GIT_HOST}:dtanabe/envy.git" "${ENVY_ROOT}"
fi

# now that the repo is checked out, make sure our "jump" files are properly
# created
if ! envy_files verify; then
	echo "Confirm changes? (y/n) "
	read -r REPLY && [ "${REPLY}" = "y" ]
	envy_files write
fi

echo "Detected platform: $PLATFORM"
echo "Repository root: $REPOS_ROOT"
echo "Envy checkout location: $ENVY_ROOT"
echo
