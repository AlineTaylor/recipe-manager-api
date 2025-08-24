# frozen_string_literal: true

# moved from original recipes controller for better soc
module LabelActions
  extend ActiveSupport::Concern

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

  def label_params
    params.require(:label).permit(:vegetarian, :vegan, :gluten_free, :dairy_free)
  end
end
