class AdminsController < EmployeesController
	# before_filter :authorize
	 before_filter :authorize
	 before_filter :isAdmin, only:[:new, :create]
  	 # before_filter :correct_user, only:[:edit, :update]
	def show
		@admin = Employee.find(params[:id])
	end

	def new
		@admin = Admin.new		
	end

	def create
		@admin = Admin.new(params[:admin])
		if @admin.save
			if admin?
				flash[:success]="添加成功"
				redirect_to '/sys/signup'
			else
			sign_in @admin
			flash[:success] = "Welcome"
			redirect_to @admin
			end
		else
			render 'new'
		end
	end

	def edit
		@admin = Admin.find(params[:id])
	end

	def update
		@admin = Admin.find(params[:id])
		if @admin.update_attributes(params[:admin])
			 #do something
			if admin?			 	
		      flash[:success] = "Profile updated"
		      redirect_to '/sys/info'
		  	else
		  	  flash[:success]="Profile updated"
		      render js: "更新成功"
		    end
	    else
	      render 'edit'
	    end
	end
  
end
