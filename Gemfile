# frozen_string_literal:true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'active_model_serializers', '~> 0.10'
gem 'active_storage_validations'
gem 'aws-sdk-s3'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cancancan'
gem 'cocoon'
gem 'decent_exposure', '~> 3.0'
gem 'devise', '~> 4.8'
gem 'doorkeeper'
gem 'dry-monads'
gem 'dry-validation'
gem 'gon'
gem 'jbuilder', '~> 2.7'
gem 'mysql2'
gem 'oj'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
gem 'redis', '~> 4.5', '>= 4.5.1'
gem 'redis-rails'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim-rails', '~> 3.3'
gem 'thinking-sphinx'
gem 'turbolinks', '~> 5'
gem 'unicorn'
gem 'webpacker', '~> 5.0'
gem 'whenever', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capistrano', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capybara', '~> 3.35', '>= 3.35.3'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'rspec-rails', '~> 5.0', '>= 5.0.2'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  # gem 'rack-mini-profiler', '~> 2.0'
  gem 'launchy', '~> 2.5'
  gem 'listen', '~> 3.3'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
