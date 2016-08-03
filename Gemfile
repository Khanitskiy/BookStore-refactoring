source 'https://rubygems.org'
ruby "2.2.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'bootstrap-sass', '~> 3.3.5'
gem 'devise'
gem 'rails_admin'
gem 'cancancan', '~> 1.10'
gem 'omniauth-facebook'
gem 'carrierwave'
gem 'cloudinary'
gem 'ckeditor'
gem 'rails-jcarousel'
gem 'owlcarousel-rails'
gem 'pg_search'
gem "breadcrumbs_on_rails"
gem 'kaminari'
gem 'jquery-star-rating-rails'
gem 'country_select'
gem 'wicked'
gem 'virtus'
gem 'aasm'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'simplecov', '0.10.0', :require => false, :group => :test
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '= 2.2.1' 
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  #rspec
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'

  gem 'rubocop', require: false
  gem "rubycritic", :require => false
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'rspec-collection_matchers'
  gem 'rake'
end

group :production do
  #gem 'pg'
  gem 'rails_12factor'
end
