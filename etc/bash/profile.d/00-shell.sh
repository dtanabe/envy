# shellcheck shell=bash

case "$-" in 
  *i*)
    w
    set -o vi
    ;;
esac
