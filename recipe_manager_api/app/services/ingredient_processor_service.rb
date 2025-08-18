# frozen_string_literal: true

# removing ingredient processing logic from the recipe controller for better soc

class IngredientProcessorService
  def self.process_ingredient_lists(ingredient_lists_data)
    return unless ingredient_lists_data.present?

    if ingredient_lists_data.is_a?(Array)
      process_array_format(ingredient_lists_data)
    elsif ingredient_lists_data.is_a?(Hash)
      process_hash_format(ingredient_lists_data)
    end
  end

  def self.process_single_ingredient_list(ingredient_list_data)
    return ingredient_list_data unless ingredient_list_data[:ingredient_attributes]&.dig(:ingredient).present?

    ingredient_name = ingredient_list_data[:ingredient_attributes][:ingredient].strip
    ingredient = find_or_create_ingredient(ingredient_name)
    
    ingredient_list_data[:ingredient_id] = ingredient.id
    ingredient_list_data.delete(:ingredient_attributes)
    ingredient_list_data
  end

  private

  def self.process_array_format(ingredient_lists)
    ingredient_lists.each do |list|
      process_single_ingredient_list(list)
    end
  end

  def self.process_hash_format(ingredient_lists)
    ingredient_lists.each do |_key, list|
      process_single_ingredient_list(list)
    end
  end

  def self.find_or_create_ingredient(ingredient_name)
    # apparently, using find_by with downcase allows for better performance compared to SQL 'where' function
    Ingredient.find_by('LOWER(ingredient) = ?', ingredient_name.downcase) ||
      Ingredient.create!(ingredient: ingredient_name)
  end
end
