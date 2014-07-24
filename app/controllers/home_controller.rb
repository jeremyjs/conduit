class HomeController < ApplicationController
  before_filter :require_login

  def dashboard
    @widgets = Widget.all
  end

  def email
    AlertsMailer.send_email(current_user).deliver
    redirect_to '/'
  end

  private
  def require_login
    unless current_user
      redirect_to new_user_session_url, notice: "You must login to use Conduit!"
    end
  end
end
