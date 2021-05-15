#!/usr/bin/env bash
set -euo pipefail

root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. >/dev/null 2>&1 && pwd )"
cache_dir="${root_dir}/.cache"
cache_fonts_dir="${cache_dir}/fonts"
input_fonts_dir="${cache_fonts_dir}/input"
input_fonts_zip="${cache_fonts_dir}/input.zip"
url="https://input.djr.com/build/?fontSelection=whole&a=0&g=0&i=serif&l=serif&zero=slash&asterisk=0&braces=0&preset=default&line-height=1.3&accept=I+do&email="

if [ -f "${input_fonts_zip}" ]; then
  echo "Using cached zip file here: \"${input_fonts_zip}\""
else
  echo "Didn't find fonts here: \"${input_fonts_zip}\""
  echo "Downloading from:"
  echo "    ${url}"
  mkdir -p "${cache_fonts_dir}"

  curl -sSL "${url}" -o "${input_fonts_zip}"
fi

unzip "${input_fonts_zip}" -d "${input_fonts_dir}"
find "${input_fonts_dir}" -name '*.ttf' -exec cp {} /Library/Fonts/ \;
rm -fr "${input_fonts_dir}"
