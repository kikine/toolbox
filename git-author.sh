#!/bin/sh

COUNT=`cd $1 && git log | grep "OLD_NAME" | wc -l`
echo "count = $COUNT"

if [ "$COUNT" -gt "0" ]; then
    cd $1 && git filter-branch -f --env-filter '
    OLD_EMAIL="shuaicj@gmail.com"
    CORRECT_NAME="shuaicj"
    CORRECT_EMAIL="shuaicj@gmail.com"
    if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
    then
        export GIT_COMMITTER_NAME="$CORRECT_NAME"
        export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
    fi
    if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
    then
        export GIT_AUTHOR_NAME="$CORRECT_NAME"
        export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
    fi
    ' --tag-name-filter cat -- --branches --tags && \
    git push --force --tags origin 'refs/heads/*' && \
    git st
fi
