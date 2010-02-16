class SessionsController < ApplicationController
	def create
		respond_to do |format|
			if user = User.authenticate( params[:username], params[:password] )
				session[:user_id] = user.id
				flash[:notice] = 'Login Successful'
				format.html { redirect_to( root_path ) }
			else
				flash[:error] = "Invalid Username/Password"
				format.html { redirect_to( login_path ) }
			end
		end
	end

	def destroy
		reset_session
		flash[:notice] = 'Successfully logged out'
		redirect_to root_path
	end

end
