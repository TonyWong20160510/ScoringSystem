require 'rubygems' 
require 'json'
class SysManagementsController < ApplicationController	
	before_filter :authorize
	before_filter :isAdmin
	def index
	end
	def new
		phase=Time.now.strftime("%Y%m%d")
		isExist=MasterTerm.find_by_phase("#{phase}期")
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
		sqlDate=MasterTerm.find_by_sql("select created_at from master_terms group by date_format(created_at,'%Y%m')")
		@termDate=Array.new
		sqlDate.each{|v| @termDate<<[v["created_at"].strftime("%Y%m")]}

		sqlPhase=MasterTerm.find_by_sql("select phase from master_terms")
		@termPhase=Array.new
		sqlPhase.each{|v| @termPhase<<[v["phase"]]}
	end

	def result
		#当前期数
		# phase=Time.now.strftime("%Y%m%d")
		phase=params[:termPhase]
		#月份
		date=params[:termDate]	

		#临时变量
		temp=0		
		#打分人数
		voteNumber=Mark.find_by_sql("select employee_id from marks where term_phase='#{phase}' group by employee_id")	
	    #定义各部门平均分列表
		@AverageDepartScoreList=Array.new
		for i in 1..7
			departScore=Mark.find_by_sql("select department_score from marks where department_id=#{i} and term_phase='#{phase}' group by employee_id")
			for j in  1..departScore.count
				temp = temp + departScore[j-1]["department_score"].to_f
			end	
			#部门平均分hash列表
			departScoreList=Hash.new	
			departname=Department.find_by_sql("select name from departments where id=#{i}")[0]["name"]
			departScoreList["部门"]=departname			
			#得到各部门平均分(四舍五入到两位小数)
			# departScoreList["分数"]=((temp.to_f*100/voteNumber.count.to_f).round).to_f/100
			departScoreList["分数"]=(temp.to_f/voteNumber.count.to_f)*100.round.to_f/100
			departScoreList["操作"]="<a href='#' id=departmentId-#{i} onclick=getDetail('departmentId-#{i}')>更多</a>"
			@AverageDepartScoreList<<departScoreList
			temp = 0 
		end

		#定义各部门主管列表
		@AverageMasterScorelist=Array.new
		for i in 1..7				
			masteridList=Array.new
			#各个部门下主管的id
			masterid=Master.find_by_sql("select id from masters where department_id=#{i}")
			#人员所属部门名称
			departname=Department.find_by_sql("select name from departments where id=#{i}")[0]["name"]
			#得到当前各部门主管id列表
			for j in 1..masterid.count
				masteridList<<masterid[j-1]["id"]
			end
			#得到各部门主管的平均分
			for k in masteridList
				
				avgScore=Hash.new				
				#先求和再算平均数，这样也方便日后修改平均数的算法,而且直接求平均数会有小数点问题
  				masterScore=Mark.find_by_sql("select sum(CONVERT(master_score,SIGNED)) as totle from marks where department_id=#{i} and master_id=#{k} and term_phase='#{phase}'")
				# temp=((masterScore[0]["totle"].to_f*100/voteNumber.count.to_f).round).to_f/100
				temp=masterScore[0]["totle"].to_f/voteNumber.count.to_f
				mastername=Master.find_by_sql("select name from masters where id=#{k}")[0]["name"]	
				avgScore["姓名"]=mastername
				avgScore["部门"]=departname				
				avgScore["分数"]=temp
				avgScore["操作"]="<a href='#' id=masterId-#{k} onclick=getDetail('masterId-#{k}') >更多</a>"
				# avgScore["#{mastername}"]=temp				
				@AverageMasterScorelist<<avgScore
			end		
			# @AverageMasterScorelist["#{i}"]=aveScore
		end
		
		 respond_to do |format|
				format.html
				format.json {render json: {:depart=>@AverageDepartScoreList.to_json,:master=>@AverageMasterScorelist.to_json}}			
			end
	end

	def detail
		departID=params[:departID]
		masterID=params[:masterID]		
		termPhase=params[:termPhase]
		
		@EmployeesList=Array.new
		if departID
			sql="SELECT a.id,a.name,b.department_score as 'score' FROM employees a,marks b WHERE a.id=b.employee_id AND b.department_id=#{departID} AND b.term_phase='#{termPhase}' group by a.name"
			# sql="select id,name from employees where id in (select employee_id from marks where department_id=#{departID} and term_phase='#{termPhase}')"
		else 
			sql="SELECT a.id,a.name,b.master_score as 'score' FROM employees a,marks b WHERE a.id=b.employee_id AND b.master_id=#{masterID} AND b.term_phase='#{termPhase}'"
			# sql="select id,name from employees where id in (select employee_id from marks where  master_id=#{masterID} and term_phase='#{termPhase}')"
		end
		employee=Employee.find_by_sql("#{sql}")
		for i in 1..employee.count
			employeeList=Hash.new
			employeeList["id"]=employee[i-1]["id"]
			employeeList["name"]=employee[i-1]["name"]
			employeeList["score"]=employee[i-1]["score"]
			@EmployeesList<<employeeList
		end
		respond_to do |format|
			format.html
			format.json {render json: {:employees=>@EmployeesList.to_json}}			
		end
	end
end
