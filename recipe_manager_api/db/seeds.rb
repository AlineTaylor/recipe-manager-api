# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Demo user
User.where(email: 'demo@example.com').destroy_all

demo_user = User.create!(
  email: 'demo@example.com',
  email_confirmation: 'demo@example.com',
  password: 'demodemo',
  password_confirmation: 'demodemo',
  first_name: 'Demo',
  last_name: 'User',
  preferred_system: 'metric'
)

# Sample recipes
recipe1 = demo_user.recipes.create!(
  title: 'Classic Pancakes',
  description: 'Fluffy pancakes perfect for breakfast.',
  servings: 4,
  cooking_time: 15,
  favorite: true,
  shopping_list: false
)

['Flour', 'Milk', 'Eggs', 'Baking Powder', 'Salt', 'Sugar', 'Butter'].each do |ingredient_name|
  ingredient = Ingredient.find_or_create_by!(ingredient: ingredient_name)
  recipe1.ingredient_lists.create!(ingredient: ingredient, metric_qty: 1, metric_unit: 'cup')
end

recipe1.instructions.create!([
  { step_number: 1, step_content: 'Mix dry ingredients together.' },
  { step_number: 2, step_content: 'Add milk and eggs, whisk until smooth.' },
  { step_number: 3, step_content: 'Heat butter in pan, pour batter, cook until golden.' }
])

recipe1.create_label!(
  vegetarian: false,
  vegan: false,
  gluten_free: false,
  dairy_free: false
)

recipe2 = demo_user.recipes.create!(
  title: 'Simple Garden Salad',
  description: 'A fresh and easy salad.',
  servings: 2,
  cooking_time: 0,
  favorite: false,
  shopping_list: true
)

['Lettuce', 'Tomato', 'Cucumber', 'Olive Oil', 'Salt', 'Pepper'].each do |ingredient_name|
  ingredient = Ingredient.find_or_create_by!(ingredient: ingredient_name)
  recipe2.ingredient_lists.create!(ingredient: ingredient, metric_qty: nil, metric_unit: nil)
end

recipe2.instructions.create!([
  { step_number: 1, step_content: 'Chop all vegetables.' },
  { step_number: 2, step_content: 'Combine in bowl, drizzle with olive oil.' },
  { step_number: 3, step_content: 'Season with salt and pepper, toss and serve.' }
])

recipe2.create_label!(
  vegetarian: true,
  vegan: true,
  gluten_free: true,
  dairy_free: true
)

puts 'Demo user and sample recipes seeded.'
