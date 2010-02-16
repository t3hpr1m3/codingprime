class SessionsController < ApplicationController
	def create
		session[:user_id] = params[:password]
		flash[:notice] = 'Successfully logged in'
		redirect_to root_path
	end

	def destroy
		reset_session
		flash[:notice] = 'Successfully logged out'
		redirect_to root_path
	end

end
