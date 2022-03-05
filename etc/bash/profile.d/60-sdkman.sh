# shellcheck shell=bash
# shellcheck disable=SC1090
# SC1090: Ignored because we're intentionally sourcing arbitrary paths

# shellcheck source=/dev/null
[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
