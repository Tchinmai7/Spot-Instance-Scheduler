require 'aws-sdk'
class Job < ApplicationRecord
  belongs_to :user
  def prepare_config (region,akid,secret)
    Aws.config.update({
        region: region,
        credentials: Aws::Credentials.new(akid, secret)
  })
  end
  def start_job (current_user,region,instance_type)
        current_user.delay.call_spot_instances(1,region,instance_type)
  end
end
