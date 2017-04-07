require 'rubygems'
require 'net/ssh'
require 'aws-sdk'
class Job < ApplicationRecord
    belongs_to :user
    attr_accessor :region, :akid, :secret

    def self.prepare_config (region,akid,secret)
        @region = region
        @akid = akid
        @secret = secret
    end 

    def self.get_image_id (region)
        case region
        when "ap-northeast-1"
            return "ami-1a62467d"
        when "us-east-1"
            return "ami-bcd95caa"
        when "us-west-1"
            return "ami-e1095381"
        when "eu-west-1"
            return "ami-2acaf54c"
        when "eu-central-1"
            return "ami-2acaf54c"
        when "ap-southeast-1"
            return "ami-3d02be5e"
        when "ap-southeast-2"
            return "ami-a1dfd0c2"
        when "sa-east-1"
            return "ami-f10c6f9d"
        end
    end

    def self.start_job (current_user,region,instance_type,akid,secret,image,command)
        ec2 = Aws::EC2::Client.new(
            region: region,
            credentials: Aws::Credentials.new(akid, secret)
        )
        system("newDate=$(date +%Y-%m-%dT%H:%M:%S); 
         oldDate=$(date --date='80 days ago' +%Y-%m-%dT%H:%M:%S);
          aws ec2 describe-spot-price-history --instance-types #{instance_type}  --product-description \"Linux/UNIX (Amazon VPC)\" --availability-zone #{region}a --start-time $oldDate --end-time $newDate > lib/awshistory.json")
          #system("lib/cron.sh #{instance_type} #{region}a")
          #sleep (300)
          cost = current_user.optimal_cost_function("lib/awshistory.json",1)
          #TODO: Create Subnet,Group?
          Rails.logger.info "The computed cost is #{cost}"
          system("aws ec2 create-key-pair --key-name #{current_user.id} --query 'KeyMaterial' --output text > lib/#{current_user.id}.pem")
          system("aws ec2 create-security-group --group-name #{current_user.id} --description #{current_user.id} > lib/security_group.txt")
          system("aws ec2 authorize-security-group-ingress --group-name #{current_user.id} --protocol all --port 0-65535 --cidr 0.0.0.0/0")
          sleep(200)
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
                  key_name: "#{current_user.id}", 
                  placement: {
                    availability_zone: "#{region}a", 
                  }, 
                  security_group_ids: [
                      "#{group_id}", 
                  ]
               #   , 
               #  "network_interfaces": [
               #     {
               #         "device_index": 0,
               #         "associate_public_ip_address": true
               #     }
               #   ]
              }, 
              spot_price: "#{cost}", 
              type: "one-time", 
          })
          Rails.logger.info "The response is #{resp}"
          spot_instance_request_id = resp.spot_instance_requests[0].spot_instance_request_id
          sleep(200)
          Rails.logger.info "Woke up from sleep. About to print values"
          dns_name = get_instance_details(ec2, spot_instance_request_id)
          sleep(200)
          Rails.logger.info "Woke up from sleep. About to ssh and run"
          ssh_and_run(dns_name, image, command, current_user.id)
    end

    def self.get_instance_details (ec2,spotid)
        resp = ec2.describe_instances(filters:[{ name: "spot-instance-request-id", values: ["#{spotid}"] }])
        Rails.logger.info "the value is #{resp.reservations[0].instances[0].public_dns_name}"
        return resp.reservations[0].instances[0].public_dns_name
    end

    def self.ssh_and_run(dns_name,image,command,uid)
        system("scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i lib/#{uid}.pem lib/setup.sh ubuntu@#{dns_name}:~/ ")
        Net::SSH.start(dns_name,"ubuntu", :keys => "lib/#{uid}.pem") do|ssh|
            output = ssh.exec "curl -sSL https://get.docker.com/ | sh" 
            ssh.exec "docker run -d #{command} #{image}"
            Rails.logger.info "ssh execution done. with output as #{output}"
        end
        Rails.logger.info "ssh execution done."
    end

end
