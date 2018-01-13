class CredentialMailer < ApplicationMailer
  
  def info_email(user, pass)
    @user = user
    @user_pass = pass
    mail(to: @user.email, subject: 'Login Credentials for YMCA ATTENDANCE PORTAL')
  end
  
end
