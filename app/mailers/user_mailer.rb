class UserMailer < ApplicationMailer
  # default from: 'Recordstage'

  # def round_email(user)
  #   @user = user
  #   @recipients = User.round_emails
  #   mail(from: 'Recordstage <recordstagehelp@gmail.com>',to: @user.email, subject: 'New Recordstage Round Starting')
  # end

  def round_email(user)
    @user = user
    mail(from: 'Recordstage <recordstagehelp@gmail.com>',to: "noreply@recordstage.com", :bcc => ENV['EMAIL_LIST'], subject: 'Recordstage Voting Starts Now!')
  end
  # def announcement_email(user)
  #   @user = user
  #   mail(from: 'Recordstage <recordstagehelp@gmail.com>',to: @user.email, subject: 'Recordstage Updates')
  # end
end


