class Recipe < ApplicationRecord
# validations
  validates :title, presence: true,length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
  validates :servings, :cooking_time, presence: true, numericality: { only_integer: true }, length: { maximum: 3 }
  validates :description, length: { maximum: 1000, too_long: "%{count} characters is the maximum allowed" }, allow_blank: true

  # associations
  belongs_to :user
  has_many :instructions, dependent: :destroy
  has_one :label, dependent: :destroy
  has_many :ingredient_lists, dependent: :destroy
  has_many :ingredients, through: :ingredient_lists

  # nested attributes
  accepts_nested_attributes_for :instructions, allow_destroy: true
  accepts_nested_attributes_for :ingredient_lists, allow_destroy: true
  accepts_nested_attributes_for :label
  # also added recipe pictures via active storage: same as user profile pictures
  has_one_attached :picture
end
