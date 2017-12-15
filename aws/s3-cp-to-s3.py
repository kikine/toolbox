#!/usr/bin/env python

import boto3

SRC_BUCKET = 'src-bucket'
SRC_DIR = 'src-dir/'
DST_BUCKET = 'dst-bucket'
DST_DIR = 'dst-dir/'

s3 = boto3.resource('s3')

objs = s3.Bucket(SRC_BUCKET).objects.filter(
    Prefix = SRC_DIR
)

count = 0

for obj in objs:
    if not obj.key.endswith('/'):
        dstKey = DST_DIR + obj.key[len(SRC_DIR):]
        print('copy s3://%s/%s ==> s3://%s/%s' % (SRC_BUCKET, obj.key, DST_BUCKET, dstKey))
        s3.Object(DST_BUCKET, dstKey).copy_from(
            CopySource = {
                'Bucket': SRC_BUCKET,
                'Key': obj.key 
            }
        )
        count += 1

print('All done! %d objects copied!' % count)
