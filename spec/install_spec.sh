#shellcheck shell=sh

Describe '.installer/install.sh'

  It 'detects missing git'
    # restrict the path to something fairly minimal that does NOT include git
    BeforeRun 'export PATH=/bin'

    When run script .installer/install.sh
    The output should eq "Checking prerequisites..."
    The status should be failure
    The error should eq "git could not be found"
  End

  It 'does not run unless HOME is defined'
    BeforeRun 'export HOME='

    When run script .installer/install.sh
    The output should eq "Checking prerequisites..."
    The status should be failure
    The error should eq "Could not determine \$HOME"
  End

End
    
