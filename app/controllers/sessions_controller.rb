class SessionsController < ApplicationController
  def new
    flash.now.alert = warden.message if warden.message.present?
  end

  def create
    warden.authenticate!
    respond_to do |format|
      format.html { redirect_to root_url(subdomain: request.subdomain), notice: 'Login Successful' }
    end
  end

  def destroy
    warden.logout
    redirect_to root_url(subdomain: request.subdomain)
  end

end
