class AddOmniauthAndJtiToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :jti, :string
    add_index :users, :jti, unique: true
  end
end
