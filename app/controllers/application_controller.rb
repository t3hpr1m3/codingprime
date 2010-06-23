# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :admin?

  def current_user
    @current_user ||= session[:user_id] && User.find( session[:user_id] )
  end

  protected
    def admin?
      if user = current_user
        return current_user.is_admin
      end
    end

    def authorize
      unless admin?
        raise PermissionDenied
      end
    end

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
end
