class TaskBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :completed, :created_at, :updated_at
end
