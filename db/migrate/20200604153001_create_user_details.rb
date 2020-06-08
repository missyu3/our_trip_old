class CreateUserDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :user_details do |t|
      t.references :user, foreign_key: true
      t.string :email, null: false
      t.text :icon
      t.timestamps
    end
    add_index :user_details, :email, unique: true
  end
end