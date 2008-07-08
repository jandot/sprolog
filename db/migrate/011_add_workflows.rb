class AddWorkflows < ActiveRecord::Migration
  def self.up
    create_table :workflows do |t|
      t.integer :project_id
      t.string :description
      t.string :graph
    end
  end

  def self.down
    drop_table :workflows
  end
end
