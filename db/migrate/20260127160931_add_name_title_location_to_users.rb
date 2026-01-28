class AddNameTitleLocationToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :title, :string
    add_column :users, :location, :string
  end
end
