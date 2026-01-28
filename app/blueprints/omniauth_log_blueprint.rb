class OmniauthLogBlueprint < Blueprinter::Base
  identifier :uid

  fields :provider

  # Extract info hash but be careful if it has sensitive data, usually it's name/email
  field :info do |auth|
    auth.info.to_h
  end

  # transform keys to string or symbols if needed, but render returns a JSON string by default
end
