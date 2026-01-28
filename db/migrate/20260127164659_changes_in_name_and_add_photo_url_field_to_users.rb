class ChangesInNameAndAddPhotoUrlFieldToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :photo_url, :string
    rename_column :users, :name, :first_name
    add_column :users, :last_name, :string
  end
end
