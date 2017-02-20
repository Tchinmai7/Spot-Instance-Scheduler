class CreateBucketConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :bucket_configs do |t|
      t.string :bucketname
      t.string :servicename
      t.string :region
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
