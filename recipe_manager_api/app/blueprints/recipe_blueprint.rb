# frozen_string_literal: true

class RecipeBlueprint < Blueprinter::Base

  identifier :id

  # views
view :normal do
    fields :title, :servings, :cooking_time, :favorite, :shopping_list

    # keeping nested attributes unserialized for now due to the complexity of the recipe controller's custom methods. Improvement opportunity.

    field :instructions do |recipe, _opts|
      recipe.instructions.map do |inst|
        {
          id: inst.id,
          step_number: inst.step_number,
          step_content: inst.step_content
        }
      end
    end

    field :ingredient_lists do |recipe, _opts|
      recipe.ingredient_lists.map do |list|
        {
          id: list.id,
          metric_qty: list.metric_qty,
          metric_unit: list.metric_unit,
          imperial_qty: list.imperial_qty,
          imperial_unit: list.imperial_unit,
          ingredient: list.ingredient ? {
            id: list.ingredient.id,
            ingredient: list.ingredient.ingredient
          } : nil
        }
      end
    end

    field :label do |recipe, _opts|
      recipe.label && {
        id: recipe.label.id,
        vegetarian: recipe.label.vegetarian,
        vegan: recipe.label.vegan,
        gluten_free: recipe.label.gluten_free,
        dairy_free: recipe.label.dairy_free
      }
    end
    field :picture_url do |recipe, _opts|
      if recipe.picture.attached?
        Rails.application.routes.url_helpers.rails_blob_url(recipe.picture, only_path: true)
      else
        nil
      end
    end
  end

  view :extended do
    include_view :normal
    field :created_at
    field :updated_at
  end
end
