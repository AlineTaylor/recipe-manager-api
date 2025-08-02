# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base

  identifier :id

  # views
  view :normal do
    fields :email, :first_name, :last_name, :preferred_system
  end

end
