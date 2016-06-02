class EmployeesController < ApplicationController
	 before_filter :authorize
	 before_filter :isAdmin, only:[:new, :create]
  	 # before_filter :correct_user, only:[:edit, :update]
	def show
		@employee = Employee.find(params[:id])
	end

	def new
		@employee = Employee.new		
	end

	def create
		@employee = Employee.new(params[:employee])
		if @employee.save
			if admin?
				flash[:success]="添加成功"
				redirect_to '/sys/info'
			else
				sign_in @employee
				flash[:success] = "Welcome"
				redirect_to @employee
			end
		else
			render 'new'
		end
	end

	def edit
		@employee = Employee.find(params[:id])
	end

	def update
		@employee = Employee.find(params[:id])
		if @employee.update_attributes(params[:employee])
			if admin?			 	
		      flash[:success] = "Profile updated"
		      redirect_to '/sys/info'
			else
				 #do something
		      flash[:success] = "Profile updated"
		      redirect_to @employee
		    end
	    else
	      render 'edit'
	    end
	end


end
