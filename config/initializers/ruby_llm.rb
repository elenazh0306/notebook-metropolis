RubyLLM.configure do |config|
  config.gemini_api_key = ENV["GEMINI_API_KEY"]
  config.default_model = "gemini-1.5-flash"
end
