Before do
  init_data_helper
  OmniAuth.config.test_mode = true
  # Set locale to English since cucumber tests are written in English
  I18n.default_locale = :en
end