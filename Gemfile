source 'https://rubygems.org'

ruby '2.6.6'

gem 'rails', '6.0.0'
gem 'openai'
gem 'httparty'
gem 'pg'
gem 'pdf-reader'
gem 'sqlite3', '1.4.2', group: [:development, :test]
gem 'dotenv-rails'
gem 'prawn' 

group :development, :test do
  gem 'database_cleaner', '1.4.1'
  gem 'capybara', '2.4.4'
  gem 'launchy'
  gem 'rspec-rails', '3.7.2'
  gem 'ZenTest', '4.11.2'
  gem 'paperclip'
  gem 'byebug'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'cucumber-rails-training-wheels'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
end

group :production do
  gem 'rails_12factor'
end

gem 'sass-rails', '~> 5.0.3'
gem 'uglifier', '>= 2.7.1'
gem 'jquery-rails'
