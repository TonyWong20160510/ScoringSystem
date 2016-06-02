class DepartmentMark < Mark
  attr_accessible :employee_id, :department_id
  belongs_to :employee
end
