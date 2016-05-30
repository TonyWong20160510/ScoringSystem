class SessionsController < ApplicationController
	
	def create
		employee = Employee.find_by_mobile(params[:session][:mobile])
		if employee && employee.authenticate(params[:session][:password])
			# session[:employee_id]=employee.id
			sign_in employee
			if admin?
				redirect_to '/sys'
			else			
				redirect_to '/mark'
			end
		else
			flash.now[:error] = '手机号或者密码错误'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
