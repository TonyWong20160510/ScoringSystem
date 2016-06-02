class MastersController < EmployeesController
	 before_filter :authorize
	 before_filter :isAdmin, only:[:new, :create]
  	 # before_filter :correct_user, only:[:edit, :update]
	def show
		@master = Employee.find(params[:id])
	end

	def new
		@master = Master.new		
	end

	def create
		@master = Master.new(params[:master])
		if @master.save
			if admin?
				flash[:success]="添加成功"
				redirect_to '/sys/signup'
			else
			sign_in @master
			flash[:success] = "Welcome"
			redirect_to @master
			end
		else
			render 'new'
		end
	end

	def edit
		@master = Master.find(params[:id])
	end

	def update
		@master = Master.find(params[:id])
		if @master.update_attributes(params[:master])
			 #do something
			if admin?			 	
		      flash[:success] = "Profile updated"
		      redirect_to '/sys/info'
		  	else
		  	  flash[:success]="Profile updated"
		      # redirect_to @master
		      render js: "更新成功"
		    end
	    else
	      render 'edit'
	    end
	end


end
