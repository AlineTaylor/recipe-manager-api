class ShareMailer < ApplicationMailer
  default from: ENV.fetch("MAIL_FROM", "no-reply@yourapp.com")
  #mailer for emails sent to user (shopping list and recipe sharing)

  # recipe sharing
  def share_recipe(recipe:, to_email:, sender_email: nil, sender_name: nil)
    @recipe = recipe
    @sender_email = sender_email
    @sender_name = sender_name
    @message = message
    subject = if @sender_name.present?
      "#{@sender_name} shared a recipe: #{@recipe&.title || 'A Recipe'}"
    else
      "A recipe was shared with you: #{@recipe&.title || 'A Recipe'}"
    end
    mail(to: to_email, subject: subject)
  end

  # shopping list sharing
  def share_shopping_list(ingredients:, to_email:, sender_email: nil, sender_name: nil)
    @ingredients = ingredients
    @sender_email = sender_email
    @sender_name = sender_name
    mail(to: to_email, subject: "Your shopping list")
  end
end
