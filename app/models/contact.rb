class Contact < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: ContactState,
    initial_state: :new,
    transition_name: :contact_states
  ]

  has_many :contact_states, class_name: "ContactState", autosave: false, dependent: :destroy

  def state_machine
    @state_machine ||= ContactStateMachine.new(self, transition_class: ContactState, association_name: :contact_states)
  end

  delegate :current_state, :can_transition_to?, :transition_to!, :allowed_transitions, to: :state_machine

  after_create :send_welcome_email

  private

  def send_welcome_email
    ContactMailer.new_contact_form(email, name).deliver_now
    transition_to!(:mailed)
  rescue => e
    Rails.logger.error("Failed to send welcome email: #{e.message}")
  end
end
