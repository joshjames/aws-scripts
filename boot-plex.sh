#!/bin/bash
#script I used to start a specific instance and update route53 dns with publicly assigned IP
# easily re-usable
# depends on the cli53 tool.
clear
instance_id=i-c6be8809
aws ec2 start-instances --instance-ids=$instance_id
echo "starting plex instance"
while state=$(aws ec2 describe-instances --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "pending"; do
  sleep 2; echo -n '.'
done; echo " $state"
PublicDnsName=$(aws ec2 describe-instances --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].PublicDnsName')
echo PublicDnsName = $PublicDnsName
echo "removing old dns entry"
cli53 rrdelete suncloud.org.au plex CNAME
sleep 2
echo "creating new dns entry"
cli53 rrcreate --replace suncloud.org.au "plex 30 CNAME $PublicDnsName."