# E-mails login data to newly created users
# and to users who have requested a new password
class PasswordMailer < ActionMailer::Base
  # E-mail login data to a new user.
  def new_user(name, email, password, url)
    @subject          = t(".subject", :default => 'Your Boxroom password')
    @body['name']     = name
    @body['password'] = password
    @recipients       = email
    @from             = Boxroom.config.mailer_from_address
    @url              = url
  end

  # E-mail login data to an exiting user
  # who requested a new password.
  def forgotten(name, email, password, url)
    @subject          = t(".subject", :default => 'Your Boxroom password')
    @body['name']     = name
    @body['password'] = password
    @recipients       = email
    @from             = Boxroom.config.mailer_from_address
    @url              = url
  end
end
