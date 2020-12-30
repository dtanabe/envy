#shellcheck shell=bash

Describe "etc/bash/profile"
  Include "etc/bash/profile"

  has_alias() {
    alias "$1" >/dev/null 2>&1
  }

  It 'exports ENVY_ROOT'
    When call echo "${ENVY_ROOT}"
    The status should be success
    The output should end with "envy"
  End

  It 'loads basic aliases'
    When call has_alias ll
    The status should be success
  End

  It 'loads cd ../../.... shortcuts'
    When call has_alias 4..
    The status should be success
  End

  It 'loads repository shortcuts'
    When call has_alias pb-envy
    The status should be success
  End
End
