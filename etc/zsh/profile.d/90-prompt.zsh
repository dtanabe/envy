# shellcheck shell=zsh

export STARSHIP_CONFIG="${ENVY_ROOT}/etc/starship/starship.toml"
eval "$(/Users/dtanabe/Applications/starship init zsh)"

# autoload -Uz vcs_info
# setopt prompt_subst

# zstyle ':vcs_info:*' enable git
# zstyle ':vcs_info:git:*' formats ":[%b] 📁 %r/%S"

# precmd() {
#     local prompt_path
#     vcs_info

#     if [[ -n ${vcs_info_msg_0_} ]]; then
#         prompt_path="$vcs_info_msg_0_"
#     else
#         prompt_path=": 📁 %/"
#     fi
#     PROMPT='%(?.   0 . %? ) %* %!'"$prompt_path"$'\n$ '
# }