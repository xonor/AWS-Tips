Here is a Bash one-liner using the AWS CLI that I put together to list enabled regions. It's not ideal but it works.

$ for i in $(aws ec2 describe-regions --output text --query "Regions[].RegionName"); do aws ec2 describe-availability-zones --query "AvailabilityZones[0].RegionName" --region $i --output text; done 2>/dev/null
