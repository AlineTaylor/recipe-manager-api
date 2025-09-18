class ApplicationMailer < ActionMailer::Base
  # GMAIL_USERNAME environment variable is the set MAIL_FROM canonical address
  default from: ENV.fetch("MAIL_FROM") { ENV.fetch("GMAIL_USERNAME") }
  layout "mailer"
end
