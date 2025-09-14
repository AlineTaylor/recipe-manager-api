class ContactMailer < ApplicationMailer
   default to: ENV.fetch("SUPPORT_EMAIL", "alineyui.taylor@gmail.com"),
          from: ENV.fetch("MAIL_FROM", "no-reply@my-recipe-manager.com")

  def contact_message(name:, email:, subject:, message:, user_id: nil)
    @name = name
    @email = email
    @message = message
    @user_id = user_id
    mail(subject: "[Contact] #{subject} — #{name}")
  end
end
