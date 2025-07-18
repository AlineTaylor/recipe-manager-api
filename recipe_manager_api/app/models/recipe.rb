class Recipe < ApplicationRecord
  belongs_to :user
  validates :title, presence: true,length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :servings, :cooking_time, presence: true, numericality: { only_integer: true }, length: { maximum: 3 }
  attribute :favorite, :shopping_list, default: false
end
