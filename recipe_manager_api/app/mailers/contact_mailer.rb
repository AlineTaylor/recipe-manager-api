class ContactMailer < ApplicationMailer
  default to: ENV.fetch("SUPPORT_EMAIL"),
          from: ENV.fetch("MAIL_FROM") { ENV.fetch("GMAIL_USERNAME") }

  def contact_message(name:, email:, subject:, message:, user_id: nil)
    @name = name
    @email = email
    @message = message
    @user_id = user_id
    mail(subject: "[Contact] #{subject} — #{name}")
  end
end
