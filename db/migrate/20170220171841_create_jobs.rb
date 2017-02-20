class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string :servicename
      t.boolean :singlecontainer
      t.string :resourcepath
      t.string :command
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
