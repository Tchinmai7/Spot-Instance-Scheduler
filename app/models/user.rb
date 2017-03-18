class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :aws_keys
  has_many :bucket_configs
  has_many :jobs
  
  def call_spot_instances(max_Cost,region,instance_type)
    system("sh lib/cron.sh #{region} #{instance_type}")
	cost=optimal_cost_function("lib/awshistory.json","lib/festivels.csv",max_Cost)	
	system("aws ec2 request-spot-instances --spot-price \"#{cost}\" --instance-count 1 --type \"one-time\" --launch-specification file://lib/specification.json >lib/request.txt")
	#to call the spot-requests - alloted, continue, low price- revise, 
	sleep 180
	system("sudo aws ec2 describe-instances >lib/response.txt")
	 file = open("lib/response.txt")
	json = file.read
	hash = JSON.parse json
	reservations=hash["Reservations"]
	pubip=nil
	instance_id=nil
	reservations.each do |reservation|
		instances=reservation["Instances"]
		instances.each do |instance|
			if(instance.has_key?("PublicIpAddress")&&instance["InstanceType"]=="r3.xlarge")
				pubip=instance["PublicIpAddress"]
				instance_id=instance["InstanceId"]
			end
		end
	end
	puts pubip
	puts instance_id
	sleep 180
	system("sudo scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i recoproject.pem lib/ffmpeg.sh ec2-user@#{pubip}:~/")
	Net::SSH.start( pubip, "ec2-user", :keys => "recoproject.pem") do|ssh|
		  output = ssh.exec "sh ffmpeg.sh"
	end
	system("sudo aws ec2 terminate-instances --instance-ids #{instance_id}")
	end 

	def optimal_cost_function(price_File,max_Cost)
		# getting the current date from the system in the dd/mm/yy format not yyyy
		currDate = Time.now.strftime("%d/%m/%y")
		 # the real data needed from the 90 days. take the least value
		 min_price = 7
		 #This param is needed for the normlized data
		 # the real data needed from the 90 days. take the max value
		 max_price = 20
		# the avg_cost has to be computed from the old values and for festivels the one day old value
		#for testing i put it as 12
		avg_cost = 12
		file = open(price_File)
		json = file.read
        if json.empty? 
            return 1
        end
		parsed = JSON.parse(json)
		total = 0.0
		counter = 0
		# this is to parse the json file and get the average ( "MEAN") value of the spot prices
		# from this we gonna find the min spot price and max spot price also
		min_price = 1.0
		max_price = 0.0
        if parsed["SpotPriceHistory"].empty? 
            return 1
        end
		parsed["SpotPriceHistory"].each do |shop|
		value = shop["SpotPrice"]
		value = value.to_f
		if(max_price < value)
		 max_price = value
		elsif min_price > value
		 	min_price = value
		end
	    total = total + value
	    counter = counter + 1
	    puts shop["SpotPrice"]
		end
		avg_cost = total/counter
		#festivels is hardcoded values of festivels if its equal
		#then you need to use the data of the previous day
		#since its going to be constant
		#puts "Enter 1 if you want to finish it quickly else 0 if you are a cheapfuck and can wait"
		#choice = gets
		  #So no the user wants the thing done quickly so he is ready to pay extra also
		  # so now i normalize the cost he is ready to bear per hour per instance
		  # this normalized data * avg_price + avg*price will be the new price
		#  puts "Enter the maximum you can spend for 1 hour spot instance"
		#  user_cost = gets
		  user_cost = max_Cost.to_f
		  puts "user cost is "
		  puts user_cost
		  puts "min_price"
		  puts min_price
		  puts "max_price"
		  puts max_price
		  probability = (user_cost - min_price)/(max_price-min_price)
		  puts "probability is"
  		  puts probability
  		  if(probability > 20 )
   			 probability = probability/100
  			end
		  optimal_cost = (probability*avg_cost)+avg_cost
		  puts "The optimal cost is "
		  puts optimal_cost
		  return optimal_cost
		end
end
