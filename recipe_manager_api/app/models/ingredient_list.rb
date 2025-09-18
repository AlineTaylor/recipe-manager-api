class IngredientList < ApplicationRecord
  # unit validation (matches frontend)
  # use explicit string array so multi-word units like "fl oz" are preserved
  VALID_UNITS = [
    'g', 'kg', 'ml', 'l', 'oz', 'lb', 'fl oz', 'cups', 'tsp', 'tbsp', 'count'
  ].freeze

  # units now optional (nil or blank allowed). When present, must be a valid unit!
  validates :metric_unit, inclusion: { in: VALID_UNITS, allow_nil: true, allow_blank: true, message: "%{value} is not a valid unit" }
  validates :imperial_unit, inclusion: { in: VALID_UNITS, allow_nil: true, allow_blank: true, message: "%{value} is not a valid unit" }

  # associations
  belongs_to :ingredient
  belongs_to :recipe

  # nested attributes
  accepts_nested_attributes_for :ingredient
end
