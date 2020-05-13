class ApplicationMailer < ActionMailer::Base
  default from: %("#{Rails.application.credentials.email[:default_name]}" <#{Rails.application.credentials.email[:default_email]}>)
  layout 'mailer'
end
