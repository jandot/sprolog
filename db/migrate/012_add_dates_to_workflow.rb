class AddDatesToWorkflow < ActiveRecord::Migration
  def self.up
    add_column :workflows, :created_at, :datetime
    add_column :workflows, :updated_at, :datetime
  end

  def self.down
    remove_column :workflows, :created_at
    remove_column :workflows, :updated_at
  end
end
