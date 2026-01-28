class RenameLinkedinUrlToUsers < ActiveRecord::Migration[8.0]
  def change
        rename_column :users, :linkedinurl, :linkedin_url
  end
end
