class AddUniquenesConstraintsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :name , presence: true
    add_index :users, :email , unique: true
    add_index :users, :phone_number , unique: true
    add_index :users, :password , presence: true
  end
end
