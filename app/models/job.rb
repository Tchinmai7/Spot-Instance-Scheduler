require 'aws-sdk'
 class Job < ApplicationRecord
   belongs_to :user
     attr_accessor :region, :akid, :secret
   def self.prepare_config (region,akid,secret)
     @region = region
     @akid = akid
     @secret = secret
   end
   def self.start_job (current_user,region,instance_type)
         ec2 = Aws::EC2::Client.new(
                 region: @region,
                 credentials: Aws::Credentials.new(@akid, @secret)
         )
        cost = current_user.optimal_cost_function("lib/awshistory.json","lib/festivels.csv",1)
        #TODO: Create Subnet, Security Group, Group, ImageID?
        system("aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > lib/#{current_user.name}.pem")
        resp = client.request_spot_instances({
            instance_count: 1, 
            launch_specification: {
            image_id: "ami-1a2b3c4d", 
            instance_type: "#{instance_type}", 
            key_name: "lib/#{current_user.name}.pem", 
            placement: {
                availability_zone: "#{region}", 
            }, 
        security_group_ids: [
            "sg-1a2b3c4d", 
        ], 
        "network_interfaces": [
            {
            "device_index": 0,
            "subnet_id": "subnet-50aa5827",
            "groups": [ "sg-44d53f20" ],
            "associate_public_ip_address": true
        }
        ]
        }, 
            spot_price: "#{cost}", 
            type: "one-time", 
        })
        #current_user.delay.call_spot_instances(1,region,instance_type)
   end
 end
