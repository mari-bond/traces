source 'https://rubygems.org'

ruby '2.2.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2'
# Use postgresql as the database for Active Record
gem 'pg'

gem 'rails-api'

gem 'spring', :group => :development
gem 'active_model_serializers', github: 'rails-api/active_model_serializers', branch: '0-8-stable'
gem "activerecord-import", ">= 0.2.0"
gem 'geocoder'
gem 'faraday'

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'byebug'
end

group :test do
  gem 'shoulda-matchers'
  gem "shoulda-callback-matchers", "~> 1.0"
  gem 'faker'
end
