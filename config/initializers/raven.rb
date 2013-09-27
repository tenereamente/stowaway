require 'raven'
unless Rails.env.test? or Rails.env.development?
  Raven.configure do |config|
    config.dsn = ENV['GETSENTRY_KEY']
  end
end
