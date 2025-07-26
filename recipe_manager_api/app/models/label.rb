class Label < ApplicationRecord
  # associations
  has_and_belongs_to_many :recipes
end
