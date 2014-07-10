class HomeController < ApplicationController
  def dashboard
    @widgets = Widget.all
  end

  def email
    AlertsMailer.send_email(current_user).deliver
    redirect_to '/'
  end
end

