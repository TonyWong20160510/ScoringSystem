class Mark < ActiveRecord::Base
  attr_accessible :department_id, :employee_id, :master_id, :term_phase, :master_score, :department_score
end
