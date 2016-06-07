class Department < ActiveRecord::Base
  attr_accessible :name
  has_many :masters
  has_many :employees

  has_many :department_masks

  #返回当前主管某期平均分(phase:20160520)
  def term_score(phase)
    m = DepartmentMark.select('round(avg(score),2) as point').where('term_phase=? and department_id=?',phase,self.id)
    m.first.point
  end

  #返回当前主管某月平均分(month:201605)
  def month_score(month)
    m = DepartmentMark.select('round(avg(score),2) as point').where('left(term_phase,6)=? and department_id=?',month,self.id)
    m.first.point
  end


  #返回所有主管某期平均分(phase:20160520)
  def self.term_score(phase)
    DepartmentMark.select('round(avg(score),2) as point').where('term_phase=?',phase).group(self.id)
  end

  #返回所有主管某月平均分(month:201605)
  def self.month_score(month)
    DepartmentMark.select('round(avg(score),2) as point').where('left(term_phase,6)=?',month).group(self.id)
  end

end
