class Step < ActiveRecord::Base
  belongs_to :task
  
  def user
    return self.task.project.user
  end
end
