class CreateDemos < ActiveRecord::Migration[8.0]
  def change
    create_table :demos do |t|
      t.timestamps

      t.string :title
    end
  end
end
