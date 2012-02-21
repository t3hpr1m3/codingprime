class SessionsController < ApplicationController
  def new
    respond_to do |format|
      if current_user
        format.html { redirect_to root_url(:subdomain => request.subdomain), :alert => 'Already logged in.  Please log out first.' }
      else
        format.html
      end
    end
  end

  def create
    respond_to do |format|
      if user = User.authenticate( params[:username], params[:password] )
        session[:user_id] = user.id
        format.html { redirect_to root_url(:subdomain => request.subdomain), :notice => 'Login Successful' }
      else
        flash[:error] = "Invalid Username/Password"
        format.html { redirect_to login_url(:subdomain => request.subdomain), :alert => 'Invalid Username/Password' }
      end
    end
  end

  def destroy
    if current_user
      reset_session
      flash[:notice] = 'Successfully logged out'
    end
    redirect_to root_url(:subdomain => request.subdomain)
  end

end
