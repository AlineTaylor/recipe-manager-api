# frozen_string_literal: true

# moving current_user logic out of the recipe controller for better soc and to minimize redundancy

module RecipeFindable
  extend ActiveSupport::Concern

  private

  def find_user_recipe(recipe_id = params[:id])
    current_user.recipes.find(recipe_id)
  end
# no more adding.includes() manually each time!
  def find_user_recipe_with_associations(recipe_id = params[:id])
    current_user.recipes.includes(:label, :ingredient_lists, :instructions).find(recipe_id)
  end
end
