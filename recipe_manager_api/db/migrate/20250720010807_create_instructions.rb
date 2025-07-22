class CreateInstructions < ActiveRecord::Migration[8.0]
  def change
    create_table :instructions do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :step_number
      t.text :step_content

      t.timestamps
    end
  end
end
