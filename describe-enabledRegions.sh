Here is a Bash one-liner using the AWS CLI that I put together to list enabled regions.

This became useful when AWS released the Hong Kong region without enabling it by defualt on all accounts.
The problem was that when automation scripts covering all regions would do describes, Hong Kong would fail.

$ for i in $(aws ec2 describe-regions --output text --query "Regions[].RegionName"); do aws ec2 describe-availability-zones --query "AvailabilityZones[0].RegionName" --region $i --output text; done 2>/dev/null
