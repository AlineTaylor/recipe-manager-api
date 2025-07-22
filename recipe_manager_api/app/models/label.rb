class Label < ApplicationRecord
  # validations
    attribute :vegetarian, :vegan, :gluten_free, :dairy_free, default: false
  # associations
  has_and_belongs_to_many :recipe
end
