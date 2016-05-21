class DepartmentsController < ApplicationController
	before_filter :authorize
  
	def show
		@department = Department.find(params[:id])
	    respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @department }
	    end
	end

	def new
		@department = Department.new
	    respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @department }
	    end
	end


	def edit
		@department = Department.find(params[:id])
	end


	def create
		@department = Department.new(params[:department])

		respond_to do |format|
		  if @department.save
		    format.html { redirect_to @department, notice: 'Department was successfully created.' }
		    format.json { render json: @department, status: :created, location: @department }
		  else
		    format.html { render action: "new" }
		    format.json { render json: @department.errors, status: :unprocessable_entity }
		  end
		end
	end


	def update
		@department = Department.find(params[:id])

		respond_to do |format|
		  if @department.update_attributes(params[:department])
		    format.html { redirect_to @department, notice: 'Department was successfully updated.' }
		    format.json { head :no_content }
		  else
		    format.html { render action: "edit" }
		    format.json { render json: @department.errors, status: :unprocessable_entity }
		  end
		end
	end

	
 
end
