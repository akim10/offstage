class UserMailer < ApplicationMailer
  # default from: 'Recordstage'

  # def round_email(user)
  #   @user = user
  #   @recipients = User.round_emails
  #   mail(from: 'Recordstage <recordstagehelp@gmail.com>',to: @user.email, subject: 'New Recordstage Round Starting')
  # end

  def round_email(lower, upper)
    mail(from: 'Recordstage <recordstagehelp@gmail.com>',to: "noreply@recordstage.com", :bcc => (User.round_emails.select("email").to_a)[lower...upper], subject: 'New Recordstage Round Starting')
  end
  # def announcement_email(user)
  #   @user = user
  #   mail(from: 'Recordstage <recordstagehelp@gmail.com>',to: @user.email, subject: 'Recordstage Updates')
  # end
end


