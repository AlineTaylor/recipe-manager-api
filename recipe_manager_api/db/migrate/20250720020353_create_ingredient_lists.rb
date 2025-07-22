class CreateIngredientLists < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_lists do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.float :metric_qty
      t.string :metric_unit
      t.float :imperial_qty
      t.string :imperial_unit

      t.timestamps
    end
  end
end
