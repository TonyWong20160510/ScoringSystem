class Employee < ActiveRecord::Base
  
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  validates :mobile, presence: true, length: { maximum: 11 }
  validates :password, length: { minimum: 6 }  
  has_secure_password

  def Employee.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def Employee.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end
	attr_accessible :department_id, :mobile, :name, :password_digest, :typename, :password, :password_confirmation
  private
		def create_remember_token
			self.remember_token = Employee.encrypt(Employee.new_remember_token)
		end
end
