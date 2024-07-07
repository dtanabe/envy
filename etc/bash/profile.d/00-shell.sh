# shellcheck shell=bash

case "$-" in
  *i*)
    set -o vi
    ;;
esac
