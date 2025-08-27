# frozen_string_literal: true

# moved from original recipes controller for better soc
module InstructionActions
  extend ActiveSupport::Concern

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

  private

  def instruction_params
    params.require(:instruction).permit(:step_number, :step_content)
  end
end
