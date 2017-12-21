**repo I use for aws scripts

- ec2-show-all.sh - spits out all ec2 instances by account profile
- ec2-start.sh - starts ec2 instance given name (requires name tag set)
- ec2-stop.sh - stops ec2 instance by name (requires name tag set)
- ebs-autosnap.py - auto EBS Snapshots via cron
- route2me.py - Change route table to route to current instance
- ebs-autosnap-lambda.py - auto EBS snapshot from lambda
- add-my-ip   - this script updates a security group with your current public ip.

**usage**

for the python scripts they depend on boto3 and your aws credentials configured.
the easiest way to get running is to use virtualenv and pip.
this repo contains a virtualenv configured and the binaries installed.
so all you need to do is navitaget to repo

>source bin/activate
./script.py


##to do.
update lambda snapshot with deployment code (ansible? and cloudformation complete stack)
    PACKAGE:
        ec2-autosnap-lambda.py
        backup_stack.yml
            deploy ec2_autosnap (lambda function)
            deploy daily_schedule (cloud watch event)
            deploy snapshot_start (SNS topic)
            deploy snapshot_failure (SNS topic)
            deploy slack_notifyer (lambda function)
            deploy snapshot_failure (lambda function)
            
update lambda snapshot code to check for existing snapshots
need to describe the tags with a meaningful description.. learnt this the hard way impossible to identify snapshots
when trying to recover!!
add tagging support > dont snapshot tagged instance with #backupschedule:never
add tagging support > how often snapshot #backupschedule:daily  #backupschedule:weekly #backupschedule:hourly #backupschedule:monthly
write universal lambda_slack_notify (supports json message pass through from any sns alert)
notify snapshot start <> sns <> lambda_slack_notify "message"
notify snapshot complete summary <> sns <> lambda_slack_notify "X number snapshots created. N time taken"
snapshot_failure_function() <> sns <> run snapshot again (if attempts >3 stop <> lambda_slack_notify "snapshot failed after 3 attempts investigate")
##large environment considerations##
    SQS message queue parallel x number snapshots at a time
    test time taken


