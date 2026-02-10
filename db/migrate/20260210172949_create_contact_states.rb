class CreateContactStates < ActiveRecord::Migration[8.1]
  def change
    create_table :contact_states do |t|
      t.string :from_state, null: false
      t.string :to_state, null: false
      t.jsonb :metadata, default: {}
      t.integer :sort_key, null: false
      t.integer :contact_id, null: false
      t.boolean :most_recent, null: false

      # If you decide not to include an updated timestamp column in your transition
      # table, you'll need to configure the `updated_timestamp_column` setting in your
      # migration class.
      t.timestamps null: false
    end

    # Foreign keys are optional, but highly recommended
    add_foreign_key :contact_states, :contacts

    add_index(:contact_states,
              %i(contact_id sort_key),
              unique: true,
              name: "index_contact_states_parent_sort")
    add_index(:contact_states,
              %i(contact_id most_recent),
              unique: true,
              where: "most_recent",
              name: "index_contact_states_parent_most_recent")
  end
end
