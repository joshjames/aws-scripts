#!/bin/bash
#simple script by joshjames
#start ec2 instance by name (requires name tag set)
# dependencies: awscli bash jq
if [[ $# -eq 0 ]] ; then
    echo 'no ec2 name provided!'
    exit 1
fi
instance_id=`aws ec2 describe-instances --filters Name=tag:Name,Values=$1 | jq '.Reservations[0] .Instances[0] .InstanceId'`
instance_id=`echo $instance_id | sed -e 's/^"//' -e 's/"$//'`
aws ec2 start-instances --instance-ids=$instance_id
echo "starting $1 instance"
while state=$(aws ec2 describe-instances --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "pending"; do
  sleep 2; echo -n '.'
done; echo " $state"
echo $1 started: details 
aws ec2 describe-instances --query "Reservations[*].Instances[*].{name: Tags[?Key==$1] | [0].Value, instance_id: InstanceId, ip_address: PrivateIpAddress, Public_ip: PublicIpAddress, state: State.Name}" --output table;


