class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.integer :reason
      t.string :phone
      t.text :message

      t.timestamps
    end
  end
end
