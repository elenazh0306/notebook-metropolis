Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost', 'capacitor://localhost' # 'https://your-custom-domain.com' - to add later
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
