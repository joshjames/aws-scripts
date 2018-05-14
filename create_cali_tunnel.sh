#!/bin/bash
#simple script by joshjames
#creates a ssh server in the states and a tunnel to it, allowing you to become a US ip address holder :)
# dependencies: awscli bash jq
#get instance id from name

name=caliproxy
echo "getting instance details for $name"
instance_id=`aws ec2 describe-instances --region us-west-1 --filters Name=tag:Name,Values=$name | jq '.Reservations[0] .Instances[0] .InstanceId'`
instance_id=`echo $instance_id | sed -e 's/^"//' -e 's/"$//'`

#get instance state
echo "Instance found: $instance_id getting power state..."
echo "....."
instance_state=`aws ec2 describe-instances --region us-west-1 --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].State.Name'`
echo "instance state: $instance_state"
#if instance is stopped turn it on
if [[ $instance_state="stopped" ]] ; then
echo "instance is off powering on..."
aws ec2 start-instances --region us-west-1 --instance-ids=$instance_id
echo "starting $name instance"
while state=$(aws ec2 describe-instances --region us-west-1 --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "pending"; do
  sleep 2; echo -n '.'
done; echo " $state"
echo $name started: details 

else
echo "instance already on... continuing..."
fi

echo "getting public IP address assigned..."

#instance is on get public IP
caliIP=`aws ec2 describe-instances --region us-west-1 --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].PublicIpAddress'`
echo "IP address aquired: $caliIP"
echo "creating ssh tunnel..."
ssh -i ~/jjs2-kp2-cali.pem -D 1338 -f -C -q -N ubuntu@54.193.115.204 -p 22
echo "ssh tunnel to california created serving proxy on port 1338"

echo "testing untunneled public IP..."
curl ifconfig.co
echo "testing tunneled public IP..."
curl --socks5-hostname 127.0.0.1:1338 ifconfig.co