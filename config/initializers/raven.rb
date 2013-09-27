require 'raven'
unless Rails.env.test?
  Raven.configure do |config|
    config.dsn = ENV['GETSENTRY_KEY']
  end
end
