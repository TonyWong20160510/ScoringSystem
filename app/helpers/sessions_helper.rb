module SessionsHelper
	def sign_in(employee)
		remember_token = Employee.new_remember_token
		cookies.permanent[:remember_token] = remember_token #失效日期设定为20年
		employee.update_attribute(:remember_token, Employee.encrypt(remember_token))
		self.current_employee = employee
	end

	def sign_in?
		!current_employee.nil?
	end

	def admin?
		# !current_employee["typename"].empty?
		if current_employee["type"].include?"Admin"
			return true
		else
			return false
		end
	end

	def current_employee=(employee)
		@current_employee = employee
	end

	def current_employee
		# @current_employee
		remember_token = Employee.encrypt(cookies[:remember_token])
		@current_employee ||= Employee.find_by_remember_token(remember_token)
	end

	def sign_out
		self.current_employee = nil
		cookies.delete(:remember_token)
	end

	def current_employee?(employee)
		employee == current_employee
	end
end
