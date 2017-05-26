#!/bin/bash
#simple script by joshjames
#stop ec2 instance by name (requires name tag set)
# dependencies: awscli bash jq
if [[ $# -eq 0 ]] ; then
    echo 'no ec2 name provided!'
    exit 1
fi
instance_id=`aws ec2 describe-instances --filters Name=tag:Name,Values=$1 | jq '.Reservations[0] .Instances[0] .InstanceId'`
instance_id=`echo $instance_id | sed -e 's/^"//' -e 's/"$//'`
aws ec2 stop-instances --instance-ids=$instance_id
echo "stopping $1 instance id: $instance_id"
while state=$(aws ec2 describe-instances --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "stopping"; do
  sleep 2; echo -n '.'
done; echo " $state"
echo $1 stopped

