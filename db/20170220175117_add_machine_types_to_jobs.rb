class AddMachineTypesToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :machine_type, :string
  end
end
