class AlertsMailer < ActionMailer::Base
  default from: "conduit.enova@gmail.com"

  def send_email(user)
    @user = user
    mail(to: user.email , subject: "Alerts")
  end
end
