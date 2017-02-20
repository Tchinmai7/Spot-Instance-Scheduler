json.extract! bucket_config, :id, :bucketname, :servicename, :region, :user_id, :created_at, :updated_at
json.url bucket_config_url(bucket_config, format: :json)