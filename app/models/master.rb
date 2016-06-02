class Master < Employee
  belongs_to :department
  has_many :master_marks

  #返回当前主管某期平均分(phase:20160520)
  def term_score(phase)
  	m = MasterMark.select('round(avg(score),2) as point').where('term_phase=? and master_id=?',phase,self.id)
  	m.first.point
  end

  #返回当前主管某月平均分(month:201605)
  def month_score(month)
    m = MasterMark.select('round(avg(score),2) as point').where('left(term_phase,6)=? and master_id=?',month,self.id)
    m.first.point
  end


  #返回所有主管某期平均分(phase:20160520)
  def self.term_score(phase)
  	MasterMark.select('round(avg(score),2) as point').where('term_phase=?',phase).group(self.id)
  end

  #返回所有主管某月平均分(month:201605)
  def self.month_score(month)
  	MasterMark.select('round(avg(score),2) as point').where('left(term_phase,6)=?',month).group(self.id)
  end
end
