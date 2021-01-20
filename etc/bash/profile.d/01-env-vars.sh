# shellcheck shell=bash

export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"

export BLOCKSIZE=K
export EDITOR=vim
export PAGER=less
export LESS=-R

# BSD grep doesn't have good grep defaults;
# GNU grep's defaults are better, but it whines if you set these environment variables
if ! grep --version 2>/dev/null | grep -q 2>/dev/null GNU; then
    export GREP_OPTIONS='--color=auto'
    export GREP_COLOR='1;32'
fi

export HISTFILESIZE=5000
export HISTSIZE=5000
export IGNOREEOF=999999

export ARTISTIC_STYLE_OPTIONS="${ENVY_ROOT}/etc/astylerc"
export LYNX_CFG="${ENVY_ROOT}/etc/lynxrc"
export LYNX_LSS="${ENVY_ROOT}/lynx/lynx.lss"
export BC_ENV_ARGS="-l"
