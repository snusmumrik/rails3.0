class UserMailer < ActionMailer::Base
  default :from => MailConfig[:admin_email]

  def signup_notification(user)
    @user = user
    @url = "#{MailConfig[:site_url]}/activate/#{user.activation_code}"
    mail(:to => user.email,
         :subject => "#{MailConfig[:site_name]} - Please activate your new account.")
  end

  def activation(user)
    @user = user
    @url = MailConfig[:site_url]
    mail(:to => user.email,
         :subject => "#{MailConfig[:site_name]} - Your account has been activated!")
  end

  def forgot_password(user)
    @user = user
    @url = "#{MailConfig[:site_url]}/reset_password/#{user.password_reset_code}"
    mail(:to => user.email,
         :subject => "#{MailConfig[:site_name]} - You have requested to change your password.")
  end

  def reset_password(user)
    @user = user
    mail(:to => user.email,
         :subject => "#{MailConfig[:site_name]} - Your password has been reset.")
  end
end
