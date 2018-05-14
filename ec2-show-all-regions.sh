#!/bin/bash
#simple script by joshjames
#filtered list of ec2 instances in a nice table
#if --profile PROFILENAME is added after script it will use that profiles access keys
# dependencies: awscli bash
for region in `aws ec2 describe-regions --output text | cut -f3`
do
     echo -e "\nListing Instances in region:'$region'..."
     aws ec2 describe-instances --region $region | jq '.Reservations[] | ( .Instances[] | {state: .State.Name, name: .KeyName, type: .InstanceType, key: .KeyName})'
done
