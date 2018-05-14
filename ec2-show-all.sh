#!/bin/bash
#simple script by joshjames
#filtered list of ec2 instances in a nice table
#if --profile PROFILENAME is added after script it will use that profiles access keys
# dependencies: awscli bash
if [ -z "$1" ];
then 
echo "listing all instances in region ap-southeast-2 - Sydney - Default Profile"
aws ec2 describe-instances --region ap-southeast-2 --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, instance_id: InstanceId, ip_address: PrivateIpAddress, Public_ip: PublicIpAddress, state: State.Name}" --output table;
echo "listing all instances in region us-west-1 - California - Default Profile"
aws ec2 describe-instances --region us-west-1 --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, instance_id: InstanceId, ip_address: PrivateIpAddress, Public_ip: PublicIpAddress, state: State.Name}" --output table;
else
echo "listing all instances in region ap-southeast-2 - Sydney - $2 Profile" 
aws ec2 describe-instances --region ap-southeast-2 --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, instance_id: InstanceId, ip_address: PrivateIpAddress, Public_ip: PublicIpAddress, state: State.Name}" $1 $2 --output table;
echo "listing all instances in region us-west-1 - California - $2 Profile"
aws ec2 describe-instances --region us-west-1 --query "Reservations[*].Instances[*].{name: Tags[?Key=='Name'] | [0].Value, instance_id: InstanceId, ip_address: PrivateIpAddress, Public_ip: PublicIpAddress, state: State.Name}" $1 $2 --output table;
fi
