class IngredientList < ApplicationRecord
  # validations
  # TODO: Add validations once input and conversion methodology are established
  # associations
  belongs_to :ingredient
  belongs_to :recipe

  # nested attributes
  accepts_nested_attributes_for :ingredient
end
