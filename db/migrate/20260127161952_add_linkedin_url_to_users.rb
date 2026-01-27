class AddLinkedinUrlToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :linkedinurl, :string
  end
end
