#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

YOUR_USERNAME="[your-username]"
YOUR_FORK_NAME="[your-fork-name]"
YOUR_FORK_GIT="https://github.com/$YOUR_USERNAME/$YOUR_FORK_NAME.git"

ORIGINAL_REPO_USERNAME="[original-repo-username]"
ORIGINAL_REPO_NAME="[original-repo-name]"
ORIGINAL_REPO_GIT="https://github.com/$ORIGINAL_REPO_USERNAME/$ORIGINAL_REPO_NAME.git"


cd /tmp

git clone $YOUR_FORK_GIT

cd /tmp/$YOUR_FORK_NAME

git remote add upstream $ORIGINAL_REPO_GIT

git fetch upstream

git merge upstream/master

git push origin master

rm -rf /tmp/$YOUR_FORK_NAME

