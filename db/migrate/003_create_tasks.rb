class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :project_id
      t.text :description
      t.string :status
      t.date :created_at

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
