class ApplicationController < ActionController::Base
  before_action :require_login
  def new_session_path(scope)
    root_path
  end

  # def not_found
  #   raise ActionController::RoutingError.new('Not Found')
  # end


  # private

  def require_login
    if !user_signed_in?
      puts params[:controller]
      if !(params[:controller] == 'home')
        redirect_to root_path
      end
    end
  end


end
