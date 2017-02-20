class CreateAwsKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :aws_keys do |t|
      t.string :name
      t.string :accessKey
      t.string :secretKey
      t.string :region
      t.boolean :default
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
