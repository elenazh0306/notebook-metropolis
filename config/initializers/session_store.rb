if Rails.env.production?
  # Allows  Heroku app to accept login cookies sent from mobile app wrapper
  Rails.application.config.session_store :cookie_store,
    key: '_your_app_session',
    same_site: :none,
    secure: true
else
  # Keep standard settings for local development
  Rails.application.config.session_store :cookie_store,
    key: '_your_app_session'
end
