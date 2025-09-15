

# controller for handling all email-sharing for the API, including recipes, shopping lists, and contact form submissions.
class ShareController < ApplicationController
  # POST /share
  # type to determine content
  def create
    type = params[:type]

    case type
    when 'recipe'
      # recipe sharing params
      recipient_email = params[:recipient_email]
      recipe_id = params[:recipe_id]
      sender_email = params[:sender_email]
      sender_name = params[:sender_name]
      message = params[:message]

      # check presence of required params
      if recipient_email.blank? || recipe_id.blank?
        render json: { error: 'Missing recipient_email or recipe_id' }, status: :bad_request
        return
      end

      # find the respective recipe
      recipe = Recipe.find_by(id: recipe_id)
      unless recipe
        render json: { error: 'Recipe not found' }, status: :not_found
        return
      end

      # send the recipe via email using ShareMailer
      begin
        ShareMailer.share_recipe(
          recipe: recipe,
          to_email: recipient_email,
          sender_email: sender_email,
          sender_name: sender_name,
          message: message
        ).deliver_later
        render json: { success: true }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end

    when 'shopping-list'
      # shopping list sharing params
      recipient_email = params[:recipient_email]
      ingredients = params[:ingredients]
      sender_email = params[:sender_email]
      sender_name = params[:sender_name]

      # check required fields
      if recipient_email.blank? || ingredients.blank?
        render json: { error: 'Missing recipient_email or ingredients' }, status: :bad_request
        return
      end

      # send the shopping list via email using ShareMailer
      begin
        ShareMailer.share_shopping_list(ingredients: ingredients, to_email: recipient_email, sender_email: sender_email, sender_name: sender_name).deliver_later
        render json: { success: true }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end

    when 'contact'
      # contact form submission params
      name = params[:name]
      email = params[:email]
      subject = params[:subject]
      message = params[:message]
      user_id = params[:user_id]

      # check required fields
      if name.blank? || email.blank? || subject.blank? || message.blank?
        render json: { error: 'Missing contact form fields' }, status: :bad_request
        return
      end

      # send the contact message via ContactMailer
      begin
        ContactMailer.contact_message(name: name, email: email, subject: subject, message: message, user_id: user_id).deliver_later
        render json: { success: true }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end

    else
      # return an error if type is invalid
      render json: { error: 'Invalid type' }, status: :bad_request
    end
  end
end
