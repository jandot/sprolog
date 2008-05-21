class ChangeOtherDateToDateTime < ActiveRecord::Migration
  def self.up
    change_column(:users, :created_at, :datetime)
    change_column(:tasks, :created_at, :datetime)
    change_column(:steps, :created_at, :datetime)
  end

  def self.down
    change_column(:users, :created_at, :date)
    change_column(:tasks, :created_at, :date)
    change_column(:steps, :created_at, :date)
  end
end
