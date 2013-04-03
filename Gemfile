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

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'sqlite3'
  gem 'rspec-core', '2.13.0'
  gem "rspec-rails", '2.13.0'
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem "shoulda-matchers", "1.4.2"
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
