#!/usr/bin/env bash
set -euo pipefail

root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"
cache_dir="${root_dir}/.cache"
cache_apps_dir="${cache_dir}/apps"
hammerspoon_app_zip="${cache_apps_dir}/hammerspoon.zip"

# Hammerspoon
defaults write org.hammerspoon.Hammerspoon MJConfigFile "${root_dir}/etc/hammerspoon/init.lua"

# Check if Hammerspoon is installed.
if [ ! -d /Applications/Hammerspoon.app ] ; then
    if [ -f "${hammerspoon_app_zip}" ]; then
      echo "Using cached zip file here: \"${hammerspoon_app_zip}\""
    else
      hammerspoon_url=$(curl -s https://api.github.com/repos/Hammerspoon/hammerspoon/releases/latest \
      | grep "browser_download_url" \
      | cut -d : -f 2,3 \
      | tr -d \" )

      echo "Downloading from:"
      echo "    ${hammerspoon_url}"

      mkdir -p "${cache_apps_dir}"

      curl -sSL ${hammerspoon_url} -o "${hammerspoon_app_zip}"
    fi

    unzip "${hammerspoon_app_zip}" -d "${cache_apps_dir}"
    mv "${cache_apps_dir}/Hammerspoon.app" /Applications
fi

# iTerm
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${root_dir}/etc/iterm2/settings.plist"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
