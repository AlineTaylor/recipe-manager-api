# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_26_201923) do
  create_table "ingredient_lists", force: :cascade do |t|
    t.integer "ingredient_id", null: false
    t.integer "recipe_id", null: false
    t.float "metric_qty"
    t.string "metric_unit"
    t.float "imperial_qty"
    t.string "imperial_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_ingredient_lists_on_ingredient_id"
    t.index ["recipe_id"], name: "index_ingredient_lists_on_recipe_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "ingredient"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instructions", force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "step_number"
    t.text "step_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_instructions_on_recipe_id"
  end

  create_table "labels", force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.boolean "vegetarian", default: false
    t.boolean "vegan", default: false
    t.boolean "gluten_free", default: false
    t.boolean "dairy_free", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_labels_on_recipe_id"
  end

  create_table "labels_recipes", id: false, force: :cascade do |t|
    t.integer "label_id", null: false
    t.integer "recipe_id", null: false
    t.index ["label_id", "recipe_id"], name: "index_labels_recipes_on_label_id_and_recipe_id"
    t.index ["recipe_id", "label_id"], name: "index_labels_recipes_on_recipe_id_and_label_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.integer "servings"
    t.integer "cooking_time"
    t.boolean "favorite", default: false
    t.boolean "shopping_list", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "email_confirmation"
    t.string "password"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "preferred_system"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "ingredient_lists", "ingredients"
  add_foreign_key "ingredient_lists", "recipes"
  add_foreign_key "instructions", "recipes"
  add_foreign_key "labels", "recipes"
  add_foreign_key "recipes", "users"
end
