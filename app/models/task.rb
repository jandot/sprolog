class Task < ActiveRecord::Base
  belongs_to :project
  has_many :steps

  def number
    # find the task number within the project not just the task id 
    project_task_ids = Project.find(self.project).tasks.find(:all, :order=>"id").map{|t| t.id}
    task_number = project_task_ids.index(self.id) + 1
    
    return 'T' + self.project.id.to_s + '_' + task_number.to_s
  end
end
