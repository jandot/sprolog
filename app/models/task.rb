class Task < ActiveRecord::Base
  belongs_to :project
  has_many :steps

  def number
    return 'T' + self.project.id.to_s + '_' + self.id.to_s
  end
end
