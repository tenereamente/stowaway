source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'cancan'
gem 'devise'
gem 'devise_invitable'
gem 'haml-rails'
gem 'pg'
gem 'rolify'
gem 'simple_form', '>= 3.0.0.rc'
gem 'unicorn'
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'hooves', require: 'hooves/default' # make unicorn the default for rails s
  gem 'git-smart', require: false
  gem 'letter_opener'
  gem 'librarian', '>= 0.0.26', require: false
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano_colors'
  gem 'hipchat'
end
