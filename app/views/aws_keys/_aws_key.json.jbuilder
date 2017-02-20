json.extract! aws_key, :id, :name, :accessKey, :secretKey, :region, :default, :created_at, :updated_at
json.url aws_key_url(aws_key, format: :json)