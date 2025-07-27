class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :update, :destroy]

  def index
    #TODO should indexing display ingredients and directions too? Or is the condensed version sufficient? How will Blueprinter play into this? Decide and update controller as need?
    current_user = User.first
    #TODO delete line above once done testing
    @recipes = current_user.recipes.includes(:labels, :ingredient_lists, :instructions)
    render json: @recipes
  end

  def show
    render json: @recipe, include: [:instructions, :ingredient_lists, :labels]
  end

  def create
    current_user = User.first
    #TODO delete line above once done testing

    # Kay, moved ingredient processing from model to controller with Bun's help - hopefully, this'll work!

    recipe_data = recipe_params.deep_dup

    # Preprocess ingredient_lists_attributes to handle ingredient lookup/creation
  if recipe_data[:ingredient_lists_attributes].present?
  ingredient_lists = recipe_data[:ingredient_lists_attributes]

  # Handles both array-style (most common) and hash-style (Rails forms)
    if ingredient_lists.is_a?(Array)
      ingredient_lists.each do |list|
        next unless list[:ingredient_attributes]&.dig(:ingredient).present?
        ingredient_name = list[:ingredient_attributes][:ingredient].strip
        ingredient = Ingredient.where('lower(ingredient) = ?', ingredient_name.downcase).first_or_create(ingredient: ingredient_name)
        list[:ingredient_id] = ingredient.id
        list.delete(:ingredient_attributes)
      end
    elsif ingredient_lists.is_a?(Hash)
      ingredient_lists.each do |_key, list|
        next unless list[:ingredient_attributes]&.dig(:ingredient).present?
        ingredient_name = list[:ingredient_attributes][:ingredient].strip
        ingredient = Ingredient.where('lower(ingredient) = ?', ingredient_name.downcase).first_or_create(ingredient: ingredient_name)
        list[:ingredient_id] = ingredient.id
        list.delete(:ingredient_attributes)
        end
    end
  end

  @recipe = current_user.recipes.build(recipe_data)
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

  # custom instructions endpoints

  def instructions
    current_user = User.first # Remove later
    recipe = current_user.recipes.find(params[:id])
    render json: recipe.instructions
  end

  def create_instruction
    current_user = User.first # Remove later
    recipe = current_user.recipes.find(params[:id])
    instruction = recipe.instructions.build(instruction_params)
    if instruction.save
      render json: instruction, status: :created
    else
      render json: { errors: instruction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_instruction
    current_user = User.first # Remove later
    recipe = current_user.recipes.find(params[:recipe_id])
    instruction = recipe.instructions.find(params[:instruction_id])
    if instruction.update(instruction_params)
      render json: instruction
    else
      render json: { errors: instruction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy_instruction
    current_user = User.first # Remove later
    recipe = current_user.recipes.find(params[:recipe_id])
    instruction = recipe.instructions.find(params[:instruction_id])
    instruction.destroy
    head :no_content
  end

  # custom ingredient list endpoints

  def ingredient_lists
    current_user = User.first # Remove later
    recipe = current_user.recipes.find(params[:id])
    render json: recipe.ingredient_lists
  end

  def create_ingredient_list
    current_user = User.first # Remove later
    recipe = current_user.recipes.find(params[:id])
    ingredient_list_data = ingredient_list_params.deep_dup

    # Check for nested ingredient attributes
    if ingredient_list_data[:ingredient_attributes] && ingredient_list_data[:ingredient_attributes][:ingredient].present?
      ingredient_name = ingredient_list_data[:ingredient_attributes][:ingredient].strip
      ingredient = Ingredient.where('lower(ingredient) = ?', ingredient_name.downcase).first_or_create(ingredient: ingredient_name)
      ingredient_list_data[:ingredient_id] = ingredient.id
      ingredient_list_data.delete(:ingredient_attributes)
    end

    ingredient_list = recipe.ingredient_lists.build(ingredient_list_data)
    if ingredient_list.save
      render json: ingredient_list, status: :created
    else
      render json: { errors: ingredient_list.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update_ingredient_list
    current_user = User.first # Remove later
    recipe = current_user.recipes.find(params[:id])
    ingredient_list = recipe.ingredient_lists.find(params[:ingredient_list_id])
    if ingredient_list.update(ingredient_list_params)
      render json: ingredient_list
    else
      render json: { errors: ingredient_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy_ingredient_list
    current_user = User.first # Remove later
    recipe = current_user.recipes.find(params[:id])
    ingredient_list = recipe.ingredient_lists.find(params[:ingredient_list_id])
    ingredient_list.destroy
    head :no_content
  end

  private

  # limiting user access to their own recipes only (see before_action at the top)
  def set_recipe
    current_user = User.first
    #TODO delete line above once done testing
    @recipe = current_user.recipes.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(
      :title, :servings, :cooking_time, :favorite, :shopping_list,
      instructions_attributes: [:id, :step_number, :step_content, :_destroy],
      ingredient_lists_attributes: [:id, :ingredient_id, :metric_qty, :metric_unit, :imperial_qty, :imperial_unit, :_destroy, { ingredient_attributes: [:id, :ingredient] }]
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
end