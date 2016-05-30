class Admin < ActiveRecord::Base
  attr_accessible :mobile, :name, :password, :password_digest
end
