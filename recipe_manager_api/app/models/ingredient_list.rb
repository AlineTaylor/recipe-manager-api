class IngredientList < ApplicationRecord
  before_validation :find_or_build_ingredient_by_name
  # validations
  # TODO: Add validations once input and conversion methodology are established
  # associations
  belongs_to :ingredient
  belongs_to :recipe
  # nested attributes
  accepts_nested_attributes_for :ingredient

  private

  # Definitely had to get Bun's help with this one - the following blocks add the logic for the method used prior to validations, mentioned at the very top (currently line 2). It'll check for the existence of an ingredient that matches the input (case-insensitive) prior to submitting a new entry. It'll use any existing ones or submit it as a new record if not already in the db.

  def find_or_build_ingredient_by_name
    # Only do this if an ingredient isn't already assigned, but attributes are present
    if ingredient.nil? && ingredient_attributes = self.ingredient_attributes
      name = ingredient_attributes["ingredient"].to_s.strip.downcase
      existing = Ingredient.where('lower(ingredient) = ?', name).first
      if existing
        self.ingredient = existing
      else
        self.build_ingredient(ingredient: ingredient_attributes["ingredient"])
      end
    end
  end

  # This lets us access nested ingredient_attributes easily
  def ingredient_attributes
    @ingredient_attributes ||= (defined?(@nested_ingredient_attributes) ? @nested_ingredient_attributes : nil)
  end

  def ingredient_attributes=(attrs)
    @nested_ingredient_attributes = attrs
  end
end
