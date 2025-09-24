class RecipesController < ApplicationController
  include RecipeFindable
  include InstructionActions
  include IngredientListActions
  include LabelActions

  before_action :authenticate_request
  before_action :set_recipe, only: [:show, :update, :destroy]

  def index
    @recipes = current_user.recipes.includes(:label, :ingredient_lists, :instructions)
    render json: RecipeBlueprint.render(@recipes, view: :normal)
  end

  def show
    render json: RecipeBlueprint.render(@recipe, view: :normal)
  end

  def create
    recipe_data = recipe_params.deep_dup
    # process ingredient lists using service object instead
    IngredientProcessorService.process_ingredient_lists(recipe_data[:ingredient_lists_attributes])
    # extract label attributes w defaults
    label_attributes = recipe_data.delete(:label_attributes) || default_label_attributes
      @recipe = current_user.recipes.build(recipe_data)
      @recipe.build_label(label_attributes)
      if params[:picture].present?
        @recipe.picture.attach(params[:picture])
      end
      if @recipe.save
        render json: RecipeBlueprint.render(@recipe, view: :normal), status: :created
      else
        render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def update
      @recipe.assign_attributes(recipe_params)
      @recipe.picture.attach(params[:picture]) if params[:picture].present?

      if @recipe.save
        render json: RecipeBlueprint.render(@recipe, view: :normal)
      else
        render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def destroy
    @recipe.destroy
    head :no_content
  end

  private

  # limiting user access to their own recipes only (see before_action at the top)
  def set_recipe
    @recipe = find_user_recipe_with_associations
  end

  def default_label_attributes
    {
      vegetarian: false,
      vegan: false,
      gluten_free: false,
      dairy_free: false
    }
  end

  def recipe_params
      params.require(:recipe).permit(
        :title, :servings, :cooking_time, :favorite, :shopping_list, :picture, :description,
        instructions_attributes: [:id, :step_number, :step_content, :_destroy],
        ingredient_lists_attributes: [
          :id, :ingredient_id, :metric_qty, :metric_unit, :imperial_qty, :imperial_unit, :_destroy,
          { ingredient_attributes: [:id, :ingredient] }
        ],
        label_attributes: [:vegetarian, :vegan, :gluten_free, :dairy_free]
      )
  end
end