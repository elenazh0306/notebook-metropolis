Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(
      'http://localhost',
      'capacitor://localhost',
      'http://localhost:3000',
      'http://127.0.0.1:3000',
      'capacitor://localhost:3000')
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
