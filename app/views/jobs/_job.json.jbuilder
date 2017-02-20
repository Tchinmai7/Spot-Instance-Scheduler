json.extract! job, :id, :servicename, :singlecontainer, :resourcepath, :command, :user_id, :created_at, :updated_at
json.url job_url(job, format: :json)