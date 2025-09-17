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

# Clear demo user
demo_email = "demo@example.com"
User.where(email: demo_email).destroy_all
puts "Demo user (if any) removed."

# Create demo user
demo_user = User.create!(
  email: demo_email,
  email_confirmation: demo_email,
  password: 'demodemo',
  password_confirmation: 'demodemo',
  first_name: 'Demo',
  last_name: 'User',
  preferred_system: 'metric'
)
puts "Demo user created."

# Sample recipes
# Recipe 1: Pancakes
recipe1 = demo_user.recipes.create!(
  title: 'Classic Pancakes',
  description: 'Fluffy pancakes perfect for breakfast.',
  servings: 4,
  cooking_time: 15,
  favorite: true,
  shopping_list: false
)

pancake_ingredients = [
  { name: 'Flour', metric_qty: 180, metric_unit: 'g' },
  { name: 'Milk', metric_qty: 300, metric_unit: 'ml' },
  { name: 'Eggs', metric_qty: 1, metric_unit: 'count' },
  { name: 'Baking Powder', metric_qty: 3.5, metric_unit: 'tsp' },
  { name: 'Salt', metric_qty: 0.5, metric_unit: 'tsp' },
  { name: 'Sugar', metric_qty: 15, metric_unit: 'g' },
  { name: 'Butter', metric_qty: 40, metric_unit: 'g' }
]

pancake_ingredients.each do |ing|
  ingredient = Ingredient.find_or_create_by!(ingredient: ing[:name])
  recipe1.ingredient_lists.create!(ingredient: ingredient, metric_qty: ing[:metric_qty], metric_unit: ing[:metric_unit])
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

#Recipe 2: Salad
recipe2 = demo_user.recipes.create!(
  title: 'Simple Garden Salad',
  description: 'A fresh and easy salad.',
  servings: 2,
  cooking_time: 0,
  favorite: false,
  shopping_list: true
)

salad_ingredients = [
  { name: 'Lettuce', metric_qty: 100, metric_unit: 'g' },
  { name: 'Tomato', metric_qty: 1, metric_unit: 'count' },
  { name: 'Cucumber', metric_qty: 0.5, metric_unit: 'count' },
  { name: 'Olive Oil', metric_qty: 1, metric_unit: 'tbsp' },
  { name: 'Salt', metric_qty: 0.25, metric_unit: 'tsp' },
  { name: 'Pepper', metric_qty: 0.25, metric_unit: 'tsp' }
]

salad_ingredients.each do |ing|
  ingredient = Ingredient.find_or_create_by!(ingredient: ing[:name])
  recipe2.ingredient_lists.create!(ingredient: ingredient, metric_qty: ing[:metric_qty], metric_unit: ing[:metric_unit])
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
