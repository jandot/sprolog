class Project < ActiveRecord::Base
  belongs_to :user
  has_many :workflows
  has_many :tasks

  def open_tasks
    self.tasks.select{|t| t.status == 'open'}
  end
  
  def owner
    self.user
  end
end
