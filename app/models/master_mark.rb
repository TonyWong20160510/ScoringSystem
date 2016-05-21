class MasterMark < Mark
  attr_accessible :employee_id, :master_id
  belongs_to :employee
end
