require 'aws-sdk'
 class Job < ApplicationRecord
   belongs_to :user
     attr_accessor :region, :akid, :secret
   def self.prepare_config (region,akid,secret)
     @region = region
     @akid = akid
     @secret = secret
   end
   
   def get_image_id (region)
    case region
        when "ap-northeast-1"
            return "ami-d8acfdbf"
        when "us-east-1"
            return "ami-9dde7f8b"
        when "us-west-1"
            return "ami-9d772efd"
        when "eu-west-1"
            return "ami-115d7777"
        when "eu-central-1"
            return "ami-6039ed0f"
        when "ap-southeast-1"
            return "ami-30cf7c53"
        when "ap-southeast-2"
            return "ami-cdcdcfae"
        when "sa-east-1"
            return "ami-0c731260"
    end
   end
   
   def self.start_job (current_user,region,instance_type)
         ec2 = Aws::EC2::Client.new(
                 region: @region,
                 credentials: Aws::Credentials.new(@akid, @secret)
         )
        system("lib/cron.sh #{instance_type} #{region}")
        sleep (180)
        cost = current_user.optimal_cost_function("lib/awshistory.json","lib/festivels.csv",1)
        #TODO: Create Subnet,Group?
        system("aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > lib/#{current_user.name}.pem")
        system("aws ec2 create-security-group --group-name #{current_user.name} --description #{current_user.name} > lib/security_group.txt")
        file = open("lib/security_group.txt")
        json = file.read
        hash = JSON.parse json
        group_id = hash["GroupId"]
        imageid = get_image_id(region)
        resp = ec2.request_spot_instances({
            instance_count: 1, 
            launch_specification: {
            image_id: "#{imageid}", 
            instance_type: "#{instance_type}", 
            key_name: "lib/#{current_user.name}.pem", 
            placement: {
                availability_zone: "#{region}", 
            }, 
        security_group_ids: [
            "#{group_id}", 
        ], 
        "network_interfaces": [
            {
            "device_index": 0,
       #     "subnet_id": "subnet-50aa5827",
       #    "groups": [ "sg-44d53f20" ],
            "associate_public_ip_address": true
        }
        ]
        }, 
            spot_price: "#{cost}", 
            type: "one-time", 
        })
        puts resp
        #current_user.delay.call_spot_instances(1,region,instance_type)
   end
 end
