## Summary
This document can be used to reference JMESPath queries for the AWS CLI.

## Main Text
JMESPath is a query language for JSON.

It is built into the AWS CLI and processes the **--query** statement of a command.


Some describe APIs have a limited set of filters.
This is when we can use **--query** to specify what information we need.

**--filter**

These queries are processed server-side (EC2).
This is used for faster response times and to reduce client side processing.
No support for operators such as '>', '<' or '=='.
Should be used for broad queries such as:

```aws ec2 describe-instances --filters 'Name=availability-zone,Values=eu-west-1a'```



**--query**

These queries are processed client-side (JMESPath).
This should be used in conjunction with --filter to pick out the specific pieces of information you require.
Support for operators such as '>', '<' or '=='.
Should be used for more specific queries such as:

```aws ec2 describe-instances --filters "Name=availability-zone,Values=eu-west-1a" --query 'Reservations[].Instances[].InstanceId'```



#### 1. List volumes that are attached to an instance by ID, type and size for the eu-west-1c AZ that are greater than 50GB:
```
aws ec2 describe-volumes \
--filter "Name=availability-zone,Values=eu-west-1c" "Name=attachment.status,Values=attached" \
--query 'Volumes[?Size > `50`].{ID:VolumeId,Size:Size,Type:VolumeType}'
```


#### 2. Find the latest Amazon Linux AMI which is HVM and root device is GP2:

(Be careful with this one as there are multiple versions of Amazon Linux such as - ecs optimized, magnetic EBS, GP2 EBS, versions 1 and 2 of ALAMI)

```
aws ec2 describe-images \
--owners amazon \
--filters "Name=name,Values=amzn*gp2" "Name=virtualization-type,Values=hvm" "Name=root-device-type,Values=ebs" \
--query "sort_by(Images, &CreationDate)[-1].ImageId" \
--output text
```



#### 3. How many volumes are in an available state that are more than 1,000 IOPS:
```
aws ec2 describe-volumes \
--filter "Name=status,Values=available" \
--query 'length(Volumes[?Iops > `1000`])'
```


#### 4. Describe all your Snapshots in a specific region that have been created after a certain date and list by their Snapshot ID, Volume ID, Description, Size and tags (supports multiple tags and shows Key and Value):
```
aws ec2 describe-snapshots --owner self --region eu-west-1 \
--query 'Snapshots[?StartTime>=`2018-02-07`].{id:SnapshotId,vid:VolumeId,Size:VolumeSize,Desc:Description, tags:Tags[*].*}' \
--output json
```


#### 5. List your 5 most recently created AMIs:
```
aws ec2 describe-images --owners self \
--query 'reverse(sort_by(Images,&CreationDate))[:5].ImageId'
```


#### 6. List unhealthy instances in an AutoScaling Group:
```
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name <ASG-name> \
--query 'AutoScalingGroups[*].Instances[?HealthStatus==`Unhealthy`].InstanceId' \
--output text
```


#### 7. List instances that a particular Security Group is attached to:
```
aws ec2 describe-network-interfaces \
--filters Name=group-id,Values=SG_ID \
--query 'NetworkInterfaces[].Attachment[].InstanceId' \
--region eu-west-1 --output json
```


#### 8. List all Elastic Network Interfaces associated with an ELB:

Sometimes you may find IPs/ENIs in your account that aren’t linked with any EC2 instances.
Quite often it’s associated with an ELB. You can use the following to confirm.
```
aws ec2 describe-network-interfaces \
--filter Name=requester-id,Values=amazon-elb \
--query 'NetworkInterfaces[*].{ENI_ID:NetworkInterfaceId,Description:Description, IP:PrivateIpAddress}' \
--region eu-west-1 --output table
```


#### 9. List all instances with a specific Tag Key, only show the instance ID, AZ and that tag:
```
aws ec2 describe-instances \
--query 'Reservations[].Instances[].[InstanceId, Tags[?Key==`Name`].[Value], Placement.[AvailabilityZone]]'
```


#### 10. List only Windows instance IDs in your account:
```
aws ec2 describe-instances \
--query 'Reservations[*].Instances[?Platform==`windows`].InstanceId'
```


### 11. Describe all your Snapshots in a specific region that have been created after a certain date and list by their ID, Volume ID, Description and tags (supports multiple tags and shows Key and Value):
```
aws ec2 describe-snapshots \
--owner self \
--region eu-west-1 \
--query 'Snapshots[?StartTime>=`2018-02-07`].{id:SnapshotId,vid:VolumeId,Desc:Description, tags:Tags[*].*}' \
--output json
```


JMESPath website:
-- http://jmespath.org/
