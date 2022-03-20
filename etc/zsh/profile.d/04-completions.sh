autoload -Uz compinit && compinit
type kubectl >/dev/null && source <(kubectl completion zsh)
