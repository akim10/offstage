class UserMailer < ApplicationMailer
  # default from: 'Recordstage'

  def round_email(user)
    @user = user
    mail(from: 'Recordstage <recordstagehelp@gmail.com>',to: @user.email, subject: 'Recordstage Voting Starts Now!')
  end
end
