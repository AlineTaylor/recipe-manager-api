class AddDefaultsToLabelsBooleans < ActiveRecord::Migration[8.0]
  def change
    # label table default boolean values
    change_column_default :labels, :vegetarian, from: nil, to: false
    change_column_default :labels, :vegan, from: nil, to: false
    change_column_default :labels, :gluten_free, from: nil, to: false
    change_column_default :labels, :dairy_free, from: nil, to: false
    # recipe table default boolean values
    change_column_default :recipes, :favorite, from: nil, to: false
    change_column_default :recipes, :shopping_list, from: nil, to: false
  end
end
