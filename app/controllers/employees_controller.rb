class EmployeesController < ApplicationController
	 before_filter :signed_in_employee, only: [:edit, :update, :show]
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
			sign_in @employee
			flash[:success] = "Welcome"
			redirect_to @employee
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
			 #do something
	      flash[:success] = "Profile updated"
	      redirect_to @employee
	    else
	      render 'edit'
	    end
	end

	
	private
    
    #before filters
    def signed_in_employee
      redirect_to signin_url, notice: "Please sign in." unless sign_in?
    end

    def correct_employee
      @employee = Employee.find(params[:id])
      redirect_to(root_path) unless current_employee?(@employee)
    end    
end
