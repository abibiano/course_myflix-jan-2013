source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '3.2.12'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem 'sidekiq'
gem 'unicorn'
gem "fabrication"
gem "faker"
gem 'carrierwave'
gem "mini_magick"
gem "fog", "~> 1.3.1"
gem 'stripe'
gem "stripe_event"
gem 'draper', '~> 1.0'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :test, :development do
  gem 'sqlite3'
  gem "rspec-rails"
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem "shoulda-matchers"
  gem 'capybara'
  gem 'capybara-email'
  gem "launchy"
  gem "database_cleaner"
end

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
end

group :development do
  gem 'letter_opener'
end

gem 'jquery-rails'
