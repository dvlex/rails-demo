class Task < ApplicationRecord
  validates :name, presence: true

  after_create_commit { broadcast_prepend_to "tasks" }
end
