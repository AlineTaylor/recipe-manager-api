class IngredientList < ApplicationRecord
  # unit validation (matches frontend)
  VALID_UNITS = %w[g kg ml l oz lb fl oz cups tsp tbsp count].freeze

  validates :metric_unit, inclusion: { in: VALID_UNITS, allow_nil: true, message: "%{value} is not a valid unit" }
  validates :imperial_unit, inclusion: { in: VALID_UNITS, allow_nil: true, message: "%{value} is not a valid unit" }

  # associations
  belongs_to :ingredient
  belongs_to :recipe

  # nested attributes
  accepts_nested_attributes_for :ingredient
end
