class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:login, :email, :password, :password_confirmation) }
  end

  Warden::Manager.after_authentication do |user,auth,opts|
    user.update_roles
  end

  Warden::Manager.after_set_user do |user, auth, opts|
    if user.email.end_with?('@enova.com') && user.left_company?
      auth.logout
      throw(:warden, :message => "User is no longer employed")
  end
end
end
