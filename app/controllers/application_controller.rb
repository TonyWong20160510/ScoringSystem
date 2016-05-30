class ApplicationController < ActionController::Base
  # protect_from_forgery
  # before_filter :authorize
  protect_from_forgery with: :exception
  include SessionsHelper
  protected
  	def authorize  		
  		unless sign_in?
  			redirect_to signin_url, :notice =>"Please log in"
  		end
    end
  	#在调用的时候，必须在authorize之后调用，不可单独调用
    def isAdmin
      unless admin?
        redirect_to root_path, :notice =>"您没有该权限！"
      end
    end
end
