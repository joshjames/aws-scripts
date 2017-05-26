#!/bin/bash
#simple script by joshjames
#filtered list of ec2 instances in a nice table
#if --profile PROFILENAME is added after script it will use that profiles access keys
# dependencies: awscli bash
if [ -z "$1" ];
then 
aws ec2 describe-instances --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, instance_id: InstanceId, ip_address: PrivateIpAddress, Public_ip: PublicIpAddress, state: State.Name}" --output table;
else
aws ec2 describe-instances --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, instance_id: InstanceId, ip_address: PrivateIpAddress, Public_ip: PublicIpAddress, state: State.Name}" $1 $2 --output table;
fi
