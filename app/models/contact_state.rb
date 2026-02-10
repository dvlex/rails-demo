class ContactState < ApplicationRecord
  # Workaround for Rails 7.1+ and Posgres JSONB columns
  def self.serialize(attr_name, *args)
    return if attr_name == :metadata
    super
  end

  include Statesman::Adapters::ActiveRecordTransition

  # If your transition table doesn't have the default `updated_at` timestamp column,
  # you'll need to configure the `updated_timestamp_column` option, setting it to
  # another column name (e.g. `:updated_on`) or `nil`.
  #
  # self.updated_timestamp_column = :updated_on
  # self.updated_timestamp_column = nil

  belongs_to :contact, inverse_of: :contact_states

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = contact.contact_states.order(:sort_key).last
    return unless last_transition.present?
    last_transition.update_column(:most_recent, true)
  end
end
