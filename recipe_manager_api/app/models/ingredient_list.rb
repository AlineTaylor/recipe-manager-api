class IngredientList < ApplicationRecord
  # validations
  # TODO: Add validations once input and conversion methodology are established
  # associations
  belongs_to :ingredient
  belongs_to :recipe
end
