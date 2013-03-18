source 'https://rubygems.org'

gem 'rails'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem 'sidekiq'
gem 'unicorn'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'sqlite3'
  gem "rspec-rails"
  gem "fabrication"
  gem "faker"
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem "shoulda-matchers"
  gem 'capybara'
  gem 'capybara-email'
  gem "launchy"
end

group :production do
  gem 'pg'
end

group :development do
  gem 'letter_opener'
end

gem 'jquery-rails'
