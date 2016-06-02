class Admin < Employee
  attr_accessible :mobile, :name, :password, :password_digest
end
