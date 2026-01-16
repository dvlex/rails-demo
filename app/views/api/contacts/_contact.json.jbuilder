json.extract! contact, :id, :name, :email, :reason, :phone, :message, :created_at, :updated_at
json.url contact_url(contact, format: :json)
