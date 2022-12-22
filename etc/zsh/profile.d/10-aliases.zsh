# shellcheck shell=bash
# shellcheck disable=SC2044,SC2139,SC2140
# SC2044: we only feed alphanumeric input into our for loop
# SC2139: we actually want these variables evaluated when they are being evaluated
# SC2140: false positive; shellcheck doesn't like `alias "thing"="that"`

# Set up basic command aliases.
alias     c='cd'
alias   cdd='cd'
alias find.='find .'
alias     e='exit'

alias k='kubectl'
alias kw='kubewatch'
alias kuebctl='kubectl'
alias kgp='kubectl get pods'
alias kwgp='watch -t "kubectl get pods"'

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
        for repo in $(find "${REPOS_ROOT}" -mindepth 1 -maxdepth 1 -type d -regex '.*/[0-9A-Za-z\.\-]*'); do
            alias "$(basename "${repo}")"="cd $repo"
        done
    fi
}
_configure
unset -f _configure
