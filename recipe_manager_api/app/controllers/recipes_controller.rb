class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :update, :destroy]

  def index
    @recipes = current_user.recipes.includes(:labels, :ingredient_lists, :instructions)
    render json: @recipes
  end

  def show
    render json: @recipe, include: [:instructions, :ingredient_lists, :labels]
  end

  def create
    current_user = User.first
    #TODO delete line above once done testing
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      render json: @recipe, status: :created
    else
      render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @recipe.update(recipe_params)
      render json: @recipe
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
    @recipe = current_user.recipes.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(
      :title, :servings, :cooking_time, :favorite, :shopping_list,
      instructions_attributes: [:id, :step_number, :step_content, :_destroy],
      ingredient_lists_attributes: [:id, :ingredient_id, :metric_qty, :metric_unit, :imperial_qty, :imperial_unit, :_destroy, { ingredient_attributes: [:id, :ingredient] }]
    )
  end
end

