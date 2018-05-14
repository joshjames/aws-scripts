#!/bin/bash
#simple script by joshjames kills ssh tunnel and shuts down host
#
# dependencies: awscli bash jq

echo "killing ssh tunnel..."
sudo pkill -f ssh
echo "tunnel disconncted."
echo "shutting down server..."
name=sydproxy
instance_id=`aws ec2 describe-instances --filters Name=tag:Name,Values=$name | jq '.Reservations[0] .Instances[0] .InstanceId'`
instance_id=`echo $instance_id | sed -e 's/^"//' -e 's/"$//'`
aws ec2 stop-instances --instance-ids=$instance_id
echo "stopping $name instance id: $instance_id"
while state=$(aws ec2 describe-instances --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "stopping"; do
  sleep 2; echo -n '.'
done; echo " $state"
echo $name stopped

