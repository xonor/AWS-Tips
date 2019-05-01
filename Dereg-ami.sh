#!/bin/bash
#Deregister AMI's in a time frame and delete the associated Snapshots.

REGION=eu-west-1
snapshotArr=()
for AMI in $(aws ec2 describe-images --owner self --region $REGION --query 'Images[?CreationDate>=`2018-03-10`&& CreationDate<=`2018-03-12`].ImageId' --output text)
do
        for snapshot in $(aws ec2 describe-images --image-ids $AMI --region $REGION --query 'Images[*].BlockDeviceMappings[*].Ebs[].SnapshotId' --output text)
        do
                snapshotArr+=($snapshot)
    done

       aws ec2 deregister-image --region $REGION --image-id $AMI
        echo "Deregistering " $AMI
done

for SNAP in "${snapshotArr[@]}"
do
         aws ec2 delete-snapshot --region $REGION --snapshot-id $SNAP
        echo "Deleting " $SNAP
done
