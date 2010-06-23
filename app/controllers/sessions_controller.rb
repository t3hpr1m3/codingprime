class SessionsController < ApplicationController
  def new
    respond_to do |format|
      if current_user
        flash[:error] = 'Already logged in.  Please log out first.'
        format.html { redirect_to( root_path ) }
      else
        format.html
      end
    end
  end

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
    if current_user
      reset_session
      flash[:notice] = 'Successfully logged out'
    end
    redirect_to root_path
  end

end
