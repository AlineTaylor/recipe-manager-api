class DropLabelsRecipesJoinTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :labels_recipes
  end
end
