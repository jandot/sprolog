class Step < ActiveRecord::Base
  belongs_to :task
  
  def number
    # find the step number within the project not just the step id 
    task_step_ids = Task.find(self.task).steps.find(:all, :order=>"id").map{|s| s.id}
    step_number = task_step_ids.index(self.id) + 1
  end

end
