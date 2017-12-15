#!/usr/bin/env python

import boto3

ec2 = boto3.resource('ec2')

instances = ec2.instances.filter(
    Filters=[
        {
            'Name': 'tag:Name',
            'Values': [
                'YOUR-TAG-PREFIX-*',
            ]
        },
        {
            'Name': 'instance-state-name',
            'Values': [
                'running',
            ]
        },
    ]
)

for instance in instances:
    print(instance.id)

