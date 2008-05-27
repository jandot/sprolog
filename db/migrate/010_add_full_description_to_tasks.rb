class AddFullDescriptionToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :full_description, :string
    rename_column :tasks, :description, :short_description
  end

  def self.down
    Tasks.find(:all).each do |task|
      if ! task.full_description.nil?
        task.short_description += task.full_description
      end
    end
    rename_column :tasks, :short_description, :description
    remove_column :tasks, :full_description
  end
end
