class Ingredient < ApplicationRecord
  # validations
  validates :ingredient, presence: true,  uniqueness: { case_sensitive: false }, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  # associations
  has_many :ingredient_lists
  has_many :recipes, through: :ingredient_lists
end
