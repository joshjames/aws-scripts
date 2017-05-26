if [[ $# -eq 0 ]] ; then
    echo 'no ec2 name provided!'
    exit 1
fi
instance_id=`aws ec2 describe-instances --filters Name=tag:Name,Values=$1 | jq '.Reservations[0] .Instances[0] .InstanceId'`
instance_id=`echo $instance_id | sed -e 's/^"//' -e 's/"$//'`
newname=$1"-clone"
aws ec2 create-image --instance-id=$instance_id --name=$newname
wait 300
image_id=`aws ec2 describe-images --filters Name=tag:Name,Values=$newname | jq '.ImageId'
//get security group
//aws ec2 run-instances --image-id=$image_id --key-name="default" --security-group-ids="$security_group" --instance-type="t2.small"