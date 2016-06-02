require 'rubygems' 
require 'json'
class SysManagementsController < ApplicationController	
	before_filter :authorize
	before_filter :isAdmin

	# def info
	# 	@departments=Department.all
	# end

	def info
		@employees = Employee.all
	end

	def new
		phase=Time.now.strftime("%Y%m%d")
		isExist=Term.find_by_phase("#{phase}期")
		if isExist
			respond_to do |format|	
				format.json {render json: {:message=>"记录已创建！"}}
			end
		else			
			#调用存储过程，在成绩单表中插入最新一期的空记录
			sql=ActiveRecord::Base.connection()
			@result=sql.select_values('call Create_phase()')	
			respond_to do |format|
				format.json {render json: @result}
			end
		end
	end

	def show
		sqlDate=Term.find_by_sql("select created_at from terms group by date_format(created_at,'%Y%m') limit 12")
		@termDate=Array.new
		sqlDate.each{|v| @termDate<<[v["created_at"].strftime("%Y%m")]}
	end

	def getterm
		date=params[:date]
		@termPhase=Term.select('phase').where('date_format(created_at,"%Y%m")= ?', date)
		respond_to do |format|
			format.json {render json:@termPhase.to_json}
		end
	end

	def echarts
		
	end	

	def result
		#当前期数
		phase=params[:termPhase]
		#当前月
		date=params[:termDate]

		@scores = []

		if 	phase.empty?		
			Department.all.each {|d|
				r={}
				r['department']=d.name
				r['master']='部门'
				r['score']=d.month_score(date)
				r['operate']="-"
				@scores << r
				d.masters.each {|m|
					r={}
					r['department']='-'
					r['master']=m.name
					r['score']=m.month_score(date)
					r['operate']="-"
					@scores << r
				}
			}
		else
			Department.all.each {|d|
				r={}
				r['department']=d.name
				r['master']='部门'
				r['score']=d.term_score(phase)
				r['operate']="<a href='#' id=departmentId-#{d.id} onclick=getDetail('departmentId-#{d.id}')>更多</a>"
				@scores << r
				d.masters.each {|m|
					r={}
					r['department']='-'
					r['master']=m.name
					r['score']=m.term_score(phase)
					r['operate']="<a href='#' id=masterId-#{m.id} onclick=getDetail('masterId-#{m.id}')>更多</a>"
					@scores << r
				}
			}
		end
		respond_to do |format|
			format.json {render json: {:scores=>@scores.to_json}}
		end
	end

	def detail
		departID=params[:departID]
		masterID=params[:masterID]		
		termPhase=params[:termPhase]		
		
		if departID
			points=DepartmentMark.select('employee_id,score').where('department_id=? and term_phase=?',departID,termPhase).order('employee_id asc')
		elsif masterID
			points=MasterMark.select('employee_id,score').where('master_id=? and term_phase=?',masterID,termPhase).order('employee_id asc')
		end
		
		@EmployeesList=Array.new
		points.each{|p|
			r={}
			r["id"]=p.employee_id
			r["name"]=p.employee.name
			r["score"]=p.score
			@EmployeesList<<r
		}
		respond_to do |format|
			format.html
			format.json {render json: {:employees=>@EmployeesList.to_json}}			
		end
	end
end
