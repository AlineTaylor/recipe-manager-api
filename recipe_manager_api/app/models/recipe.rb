class Recipe < ApplicationRecord
# validations
  validates :title, presence: true,length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :servings, :cooking_time, presence: true, numericality: { only_integer: true }, length: { maximum: 3 }

  # associations
  belongs_to :user
  has_many :instructions, dependent: :destroy
  has_and_belongs_to_many :labels
  has_many :ingredient_lists
  has_many :ingredients, through: :ingredient_lists

  # nested attributes
  accepts_nested_attributes_for :instructions, allow_destroy: true
  accepts_nested_attributes_for :ingredient_lists, allow_destroy: true
end
