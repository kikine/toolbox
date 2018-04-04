#!/usr/bin/env python

import sys
import boto3

GROUP_PREFIX = 'shuaicj-'

GROUP_NAMES = [
    'group1',
    'group2',
]

def usage():
    print('USAGE: %s %s' % (sys.argv[0], '|'.join(GROUP_NAMES)))

if len(sys.argv) < 2:
    usage()
    exit()

#
# read the list of group
#

groupList = []

for g in sys.argv[1:]:
    if g not in GROUP_NAMES:
        usage()
        exit()
    groupList.append(GROUP_PREFIX + g)


#
# pull ec2 instance info
#

ec2 = boto3.resource('ec2')

instances = ec2.instances.filter(
    Filters=[
        {
            'Name': 'tag:Name',
            'Values': [
                GROUP_PREFIX + '*',
            ]
        },
        {
            'Name': 'tag:Group',
            'Values': groupList
        },
        {
            'Name': 'instance-state-name',
            'Values': [
                'stopped',
            ]
        },
    ]
)


#
# start ec2 instances
#

def nameOf(instance):
    for tag in instance.tags:
        if tag['Key'] == 'Name':
            return tag['Value']

instances = sorted(instances, key=lambda instance: nameOf(instance))

for instance in instances:
    print('start %s' % nameOf(instance))
    instance.start()

print('Done!')

