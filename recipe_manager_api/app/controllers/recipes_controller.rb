class RecipesController < ApplicationController
  include RecipeFindable
  
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
      if @recipe.update(recipe_params)
        if params[:picture].present?
          @recipe.picture.attach(params[:picture])
        end
        render json: RecipeBlueprint.render(@recipe, view: :normal)
      else
        render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
      end
  end

  def destroy
    @recipe.destroy
    head :no_content
  end

  # custom instructions endpoints
  def instructions
    recipe = find_user_recipe
    render json: recipe.instructions
  end

  def create_instruction
    recipe = find_user_recipe
    instruction = recipe.instructions.build(instruction_params)
    
    if instruction.save
      render json: instruction, status: :created
    else
      render json: { errors: instruction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_instruction
    recipe = find_user_recipe(params[:recipe_id])
    instruction = recipe.instructions.find(params[:instruction_id])
    
    if instruction.update(instruction_params)
      render json: instruction
    else
      render json: { errors: instruction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy_instruction
    recipe = find_user_recipe(params[:recipe_id])
    instruction = recipe.instructions.find(params[:instruction_id])
    instruction.destroy
    head :no_content
  end

  # custom ingredient list endpoints
  def ingredient_lists
    recipe = find_user_recipe
    render json: recipe.ingredient_lists
  end

  def create_ingredient_list
    recipe = find_user_recipe
    ingredient_list_data = ingredient_list_params.deep_dup

    # process single ingredient with service
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

  # custom label endpoints
  def show_labels
    recipe = find_user_recipe
    render json: recipe.label
  end

  def update_labels
    recipe = find_user_recipe
    label = recipe.label || recipe.build_label

    if label.update(label_params)
      render json: label
    else
      render json: { errors: label.errors.full_messages }, status: :unprocessable_entity
    end
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
        :title, :servings, :cooking_time, :favorite, :shopping_list, :picture,
        instructions_attributes: [:id, :step_number, :step_content, :_destroy],
        ingredient_lists_attributes: [:id, :ingredient_id, :metric_qty, :metric_unit, :imperial_qty, :imperial_unit, :_destroy, { ingredient_attributes: [:id, :ingredient] }], label_attributes: [:vegetarian, :vegan, :gluten_free, :dairy_free]
      )
  end

  def instruction_params
    params.require(:instruction).permit(:step_number, :step_content)
  end

  def ingredient_list_params
    params.require(:ingredient_list).permit(
      :ingredient_id, :metric_qty, :metric_unit, :imperial_qty, :imperial_unit,
      ingredient_attributes: [:id, :ingredient] )
  end

  def label_params
    params.require(:label).permit(:vegetarian, :vegan, :gluten_free, :dairy_free)
  end
end