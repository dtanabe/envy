# shellcheck shell=bash
# shellcheck disable=SC2044,SC2139,SC2140
# SC2044: we only feed alphanumeric input into our for loop
# SC2139: we actually want these variables evaluated when they are being evaluated
# SC2140: false positive; shellcheck doesn't like `alias "thing"="that"`

# Set up coloring for LS
if [ "$(uname)" = "Darwin" ]; then
    # Mac OS X-specific
    alias ls='/bin/ls -FGw'
else
    alias ls='ls --color -F'
fi

# Set up basic command aliases.
alias     c='cd'
alias   cdd='cd'
alias find.='find .'
alias     e='exit'
alias     l='ls'
alias    ll='ls -l'
alias   lla='ls -lA'
alias    la='ls -A'

# Git aliases.
alias gco='git checkout'
alias gco-='git checkout -'
alias gcom='git-checkout-main'
alias gb='git branch'
alias gbD='git branch -D'
alias grm='git rebase origin/master --autostash'
alias gs='git status'

function _configure() {
    local i
    local cd_cmd
    local repo
    local find_opts=""

    # Map a number followed by a period or two periods to navigating up the
    # current hierarchy.
    cd_cmd='cd '
    for i in {1..10}; do
        cd_cmd="${cd_cmd}../"
        alias "${i}."="${cd_cmd}"
        alias "${i}.."="$cd_cmd"
    done
    alias ..='cd ..'

    # For each repo, create a quick keyboard shortcut to allow jumping there.
    if [ -n "${REPOS_ROOT}" ]; then
        if find . -regextype grep -regex "\0" -maxdepth 1 >/dev/null 2>&1; then
            find_opts="-regextype grep"
        fi

        # shellcheck disable=SC2086
        # SC2086: ${find_opts} needs to be word-split to work as intended
        for repo in $(find "${REPOS_ROOT}" -mindepth 1 -maxdepth 1 -type d ${find_opts} -regex ".*/[[:alnum:]-]*"); do
            alias "$(basename "${repo}")"="cd $repo"
        done
    fi
}
_configure
unset -f _configure
