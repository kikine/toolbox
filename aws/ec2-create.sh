#!/bin/bash

function create()
{
    name=
    group=
    ec2=
    ebs=
    ip=

    while [ $# -gt 0 ]
    do
        case "$1" in
            --name)  name="$2"; shift 2;;
            --group) group="$2"; shift 2;;
            --ec2)   ec2="$2"; shift 2;;
            --ebs)   ebs="$2"; shift 2;;
            --ip)    ip="$2"; shift 2;;
            *)  break;;
        esac
    done

    aws ec2 run-instances \
        --image-id ami-ffffffff \
        --instance-type "$ec2" \
        --subnet-id subnet-ffffffff \
        --private-ip-address "$ip" \
        --block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeType=gp2,VolumeSize=$ebs}" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$name},{Key=Group,Value=$group},{Key=Owner,Value=shuaicj}]" \
                             "ResourceType=volume,Tags=[{Key=Name,Value=$name},{Key=Group,Value=$group},{Key=Owner,Value=shuaicj}]" \
        --security-group-ids sg-ffffffff \
        --key-name your-key-name
}

function batchCreate()
{
    namePrefix=
    nameFrom=
    group=
    ec2=
    ebs=
    ipPrefix=
    ipFrom=
    count=

    while [ $# -gt 0 ]
    do
        case "$1" in
            --name-prefix)  namePrefix="$2"; shift 2;;
            --name-from)    nameFrom="$2"; shift 2;;
            --group)        group="$2"; shift 2;;
            --ec2)          ec2="$2"; shift 2;;
            --ebs)          ebs="$2"; shift 2;;
            --ip-prefix)    ipPrefix="$2"; shift 2;;
            --ip-from)      ipFrom="$2"; shift 2;;
            --count)        count="$2"; shift 2;;
            *)  break;;
        esac
    done

    for (( i=0; i < $count; ++i ))
    do
        name=`printf "%s-%03d" $namePrefix $[$nameFrom + $i]`
        ip="$ipPrefix.$[$ipFrom + $i]"
        create --name $name --group $group --ec2 $ec2 --ebs $ebs --ip $ip
    done
}

create --name shuaicj-test-single --group shuaicj-test --ec2 t2.micro --ebs 50 --ip 10.10.10.10

batchCreate \
    --name-prefix shuaicj-test-batch \
    --name-from 1 \
    --group shuaicj-test \
    --ec2 t2.micro \
    --ebs 50 \
    --ip-prefix 10.10.10 \
    --ip-from 11 \
    --count 4
