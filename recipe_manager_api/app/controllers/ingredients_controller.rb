class IngredientsController < ApplicationController
  # Didn't really want to create a new controller for this, but apparently, it's good RESTful practice to keep them separate, especially since ingredients are not “owned” by users or recipes, but are a global resource.
  # read-only endpoint for global access, no need for authentication.

  # GET /ingredients
  def index
    render json: IngredientBlueprint.render(Ingredient.all)
  end
end
