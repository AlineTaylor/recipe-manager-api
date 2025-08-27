# frozen_string_literal: true

# moved from original recipes controller for better soc
module IngredientListActions
  extend ActiveSupport::Concern

  def ingredient_lists
    recipe = find_user_recipe
    render json: recipe.ingredient_lists
  end

  def create_ingredient_list
    recipe = find_user_recipe
    ingredient_list_data = ingredient_list_params.deep_dup
    IngredientProcessorService.process_single_ingredient_list(ingredient_list_data)
    ingredient_list = recipe.ingredient_lists.build(ingredient_list_data)
    if ingredient_list.save
      render json: ingredient_list, status: :created
    else
      render json: { errors: ingredient_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_ingredient_list
    recipe = find_user_recipe(params[:recipe_id])
    ingredient_list = recipe.ingredient_lists.find(params[:ingredient_list_id])
    if ingredient_list.update(ingredient_list_params)
      render json: ingredient_list
    else
      render json: { errors: ingredient_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy_ingredient_list
    recipe = find_user_recipe(params[:recipe_id])
    ingredient_list = recipe.ingredient_lists.find(params[:ingredient_list_id])
    ingredient_list.destroy
    head :no_content
  end

  private

  def ingredient_list_params
    params.require(:ingredient_list).permit(
      :ingredient_id, :metric_qty, :metric_unit, :imperial_qty, :imperial_unit,
      ingredient_attributes: [:id, :ingredient]
    )
  end
end
