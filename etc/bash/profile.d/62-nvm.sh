# shellcheck shell=bash
# shellcheck disable=SC1090
# SC1090: Ignored because we're intentionally sourcing arbitrary paths

export NVM_DIR="$HOME/.nvm"

# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
