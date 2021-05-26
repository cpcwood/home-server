class ApplicationMailer < ActionMailer::Base
  default from: %("#{Rails.configuration.email_default_name}" <#{Rails.configuration.email_default_address}>)
  layout 'mailer'
end
