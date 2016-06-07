require 'rubygems'
require 'json'
class MarksController < ApplicationController
	before_filter :authorize
	def index	
		 phase=Time.now.strftime("%Y%m%d")	
		 # 判定当天是否可以进行评分 		 

		 isopen=Term.find_by_sql("select * from terms where phase='#{phase}期'")
		 if isopen.count>0
			 # @marks=Mark.all		 
			 #部门列表
			 @departmentlist=Array.new
			 departments=Department.all
			 departments.each{|v| @departmentlist<<[v["id"],v["name"]]}
			 #部门主管列表		 
			 @masterlist=Array.new
			 masters=Master.all
			 masters.each{|v| @masterlist<<[v["id"],v["name"],v["department_id"]]}					 
		else
			render text: "打分系统尚未开启!"
			# redirect_to root_path
		end

	end

	def submit
		phase=Time.now.strftime("%Y%m%d")	 

		check=Mark.find_by_sql("select * from marks where term_phase='#{phase}' and employee_id=#{current_employee["id"]}",)


		if check.count > 0
			render text: "您已经提交过评分了!"
		else
			@jsonData=JSON.parse(params[:jsonData])
			for f in @jsonData
				master_id=f["master_id"]
				employee_id=f["employee_id"]
				department_id=f["department_id"]
				term_phase=f["term_phase"]
				score=f["score"]						
				Mark.create(:master_id=>"#{master_id}",:employee_id=>"#{employee_id}",:department_id=>"#{department_id}",:term_phase=>"#{term_phase}",:score=>"#{score}")
				# Mark.create(:master_id=>"#{master_id}",:employee_id=>"#{employee_id}",:department_id=>"#{department_id}",:term_phase=>"#{term_phase}",:master_score=>"#{master_score}",:department_score=>"#{department_score}")
				# sql=ActiveRecord::Base.connection() 需要传入参数的存储过程在这里好像行不通，总是提示不能返回结果集，不知道是rails问题还是我写的格式问题
				# @result=sql.select_value("call SUBMIT_MARKS("+master_id+","+employee_id+","+department_id+",'"+term_phase+"','"+master_score+"','"+department_score+"')")
		    end		  

		end			
	end

	def score
		theScore=Hash.new
		@Score=Array.new
		phase=Time.now.strftime("%Y%m%d")
		voteNumber=Mark.find_by_sql("select employee_id from marks where term_phase='#{phase}' group by employee_id")
		sql="SELECT score FROM marks WHERE department_id=(SELECT department_id FROM employees WHERE id=#{current_employee["id"]}) AND term_phase=#{phase}"

		scores=Mark.find_by_sql(sql)
		if scores.count>0
			temp=0
			for i in 1..scores.count
				temp = temp + scores[i-1]["score"].to_f
			end
			theScore["score"]=((temp/voteNumber.count.to_f)*100).round.to_f/100
			theScore["number"]=scores.count
			@Score<<theScore
			respond_to do |format| 
			format.json{render json:{:score=>@Score.to_json} }
			end
		else
			render js: "尚无人评分"
		end
	end
	
end
