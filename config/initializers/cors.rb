Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "localhost:*", "https://lexdrel.com", "https://*.lexdrel.com"

    resource "/api/*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
