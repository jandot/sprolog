class ChangeProjectDateToDateTime < ActiveRecord::Migration
  def self.up
    change_column(:projects, :created_at, :datetime)
  end

  def self.down
    change_column(:projects, :created_at, :datetime)
  end
end
