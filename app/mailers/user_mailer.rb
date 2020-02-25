class UserMailer < ApplicationMailer
  default from: 'recordstagehelp@gmail.com'

  def round_email(user)
    @user = user
    mail(to: @user.email, subject: 'Recordstage Voting Starts Now!')
  end
end
