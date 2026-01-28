class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email, :first_name, :last_name, :title, :location, :linkedinurl, :photo_url

  # You can also add computed fields or associations here
  # field :full_name do |user|
  #   "#{user.first_name} #{user.last_name}"
  # end
end
