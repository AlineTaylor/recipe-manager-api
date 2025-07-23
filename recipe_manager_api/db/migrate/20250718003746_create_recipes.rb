class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.integer :servings
      t.integer :cooking_time
      t.boolean :favorite
      t.boolean :shopping_list

      t.timestamps
    end
  end
end
