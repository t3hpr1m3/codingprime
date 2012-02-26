# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details


  def current_user
    warden.user
  end
  helper_method :current_user

  protected

  def warden
    env['warden']
  end

  def admin?
    if user = current_user
      return user.is_admin
    end
  end
  helper_method :admin?

  def authorize
    unless admin?
      raise Exceptions::PermissionDenied
    end
  end
end
