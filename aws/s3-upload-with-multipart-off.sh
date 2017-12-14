#!/bin/bash

S3_BUCKET="BUCKET"
S3_DIR="DIR/SUBDIR"
LOCAL_DIR="/Users/shuai/data"

upload()
{
    for f in $1/*; do
        if [ -f $f ]; then
            echo "aws s3api put-object --bucket $S3_BUCKET --key $S3_DIR${f:${#LOCAL_DIR}} --body $f"
        elif [ -d $f ]; then
            upload $f;
        fi
    done
}

upload $LOCAL_DIR;
