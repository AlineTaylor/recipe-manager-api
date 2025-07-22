class CreateJoinTableLabelRecipe < ActiveRecord::Migration[8.0]
  def change
    create_join_table :labels, :recipes do |t|
      t.index [:label_id, :recipe_id]
      t.index [:recipe_id, :label_id]
    end
  end
end
