instance_type=$1
region=$2
newDate=$(date +%Y-%m-%dT%H:%M:%S);
oldDate=$(date -v -90d +%Y-%m-%dT%H:%M:%S);
aws ec2 describe-spot-price-history --instance-types $instance_type  --product-description "Linux/UNIX (Amazon VPC)" --availability-zone $region  --start-time $oldDate --end-time $newDate > awshistory.json
