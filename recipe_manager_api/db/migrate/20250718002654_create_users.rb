class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :email_confirmation
      t.string :password
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :preferred_system

      t.timestamps
    end
  end
end
