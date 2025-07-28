class Ingredient < ApplicationRecord
  # validations
  validates :ingredient, presence: true,  uniqueness: { case_sensitive: false }, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  # TODO Remember to add a reminder to user on the UI that ingredient list is global and visible to all other users!! To please not include any identifying information or private data
  # associations
  has_many :ingredient_lists
  has_many :recipes, through: :ingredient_lists
end
