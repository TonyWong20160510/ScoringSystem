class Department < ActiveRecord::Base
  attr_accessible :name
  has_many :masters
  has_many :employees
end
