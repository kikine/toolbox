#!/usr/bin/env python

import boto3

ec2 = boto3.client('ec2')

response = ec2.describe_instances(
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

for reserv in response['Reservations']:
    print(reserv['Instances'][0]['InstanceId'])


