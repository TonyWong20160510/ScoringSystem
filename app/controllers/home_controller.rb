class HomeController < ApplicationController
	before_filter :current_employee
	def index
	end
end
