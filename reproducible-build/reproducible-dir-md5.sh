#!/bin/bash
# Calculate the md5 for the whole dir content recursively.
# The result is reproducible both on MacOS and Linux.

set -eo pipefail

if [[ $# -eq 0 ]]; then
    echo "Usage: ./reproducible-dir-md5.sh [DIR]"
    exit 1
fi

dir="$1"
pwd_dir="$(pwd)"

if [[ ! -d "$dir" ]]; then
    echo "dir not exists! $dir"
    exit 1
fi

cd "$dir"

os="$(uname -s)"

if [[ "$os" = "Darwin" ]]; then
    find . \( -type f -o -type l \) -exec md5 {} \; | LC_ALL=C sort -k 2 | md5
elif [[ "$os" = "Linux" ]]; then
    find . \( -type f -o -type l \) -exec md5sum --tag {} \; | LC_ALL=C sort -k 2 | md5sum | awk '{ print $1 }'
else
    echo "Unsupported OS!"
    exit 1
fi

cd "$pwd_dir"

