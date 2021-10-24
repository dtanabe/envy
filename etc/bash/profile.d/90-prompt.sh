# shellcheck shell=bash

bash_prompt="${ENVY_ROOT}/libexec/bash-prompt"

function prompt_command {
  PS1=$($bash_prompt $?)
  [ $? ] && export PS1
}

export PROMPT_COMMAND="prompt_command; $PROMPT_COMMAND"
