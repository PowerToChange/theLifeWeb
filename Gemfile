source 'https://rubygems.org'

gem 'rails', '3.2.12'

gem 'pg'
gem 'airbrake'
gem 'thin'
gem 'decent_exposure'
gem 'active_model_serializers'
gem 'seedbank'
gem 'dotenv'
gem 'devise'
gem 'heroku'
gem 'strong_parameters'
gem 'jquery-rails'
gem 'activeadmin'
gem 'ckeditor'
gem 'select2-rails'
gem 'carrierwave'
gem 'mini_magick'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
end

group :development do
  gem 'letter_opener'
  gem 'foreman'
  gem 'bullet'
end

group :development, :test do
  gem 'debugger'
  gem 'rspec-rails'
  gem 'mail_safe'
  gem 'rails_best_practices'
  gem 'brakeman'
end

group :test do
  gem 'simplecov', require: false
  gem 'webmock', require: false

  gem 'capybara'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'shoulda-matchers'
end

group :development, :staging do
  gem 'api_taster', github: 'fredwu/api_taster'
end

group :development, :test, :staging do
  gem 'faker'
  gem 'factory_girl_rails'
end
