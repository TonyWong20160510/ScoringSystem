class Employee < ActiveRecord::Base
  
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  validates :mobile, presence: true, length: { maximum: 11 }
  validates :password, length: { minimum: 6 }  
  validates_uniqueness_of :mobile,:case_sensitive => false, :message => "该手机号已存在!"
  has_secure_password

  has_many :master_marks
  has_many :department_marks

  def Employee.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def Employee.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end
	attr_accessible :department_id, :mobile, :name, :password_digest, :type, :password, :password_confirmation
  private
		def create_remember_token
			self.remember_token = Employee.encrypt(Employee.new_remember_token)
		end
end
