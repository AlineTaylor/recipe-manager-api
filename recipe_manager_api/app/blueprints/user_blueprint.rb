# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base

  identifier :id

  # views
  view :normal do
      fields :id, :email, :first_name, :last_name, :preferred_system
      field :profile_picture_url do |user, _options|
        # if the user has a profile picture attached, the payload will include the URL
        if user.profile_picture.attached?
          Rails.application.routes.url_helpers.rails_blob_url(user.profile_picture, only_path: true)
        else
          nil
        end
      end
  end

end
