class ContactStateMachine
  include Statesman::Machine

  state :new, initial: true
  state :mailed
  state :awaiting
  state :contacted

  transition from: :new, to: :mailed
  transition from: :mailed, to: :awaiting
  transition from: :awaiting, to: :contacted

  after_transition do |model, transition|
    model.update_column(:status, transition.to_state)
  end
end
