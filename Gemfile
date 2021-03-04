source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.6'

######################################################################
# Rails Framework
######################################################################
gem 'rails'
gem 'puma'
gem 'turbolinks'

group :production do
  gem 'pg', '~> 1.2' # Must make sure libpq-dev is installed on Ubuntu
end

group :development, :test do
  gem 'sqlite3'

  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

######################################################################
# UI Framework
######################################################################
gem 'bootstrap-sass'
gem 'font-awesome-sass'

# Use SCSS for stylesheets
gem 'sass-rails'

######################################################################
# JS Framework
######################################################################
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jbuilder'

# JS assets compressor
gem 'uglifier'

# JS runtime
gem 'execjs'
gem 'mini_racer', '~>0.3.1'

######################################################################
# Utilities
#####################################################################
gem 'google_sign_in'
gem 'fullcalendar-rails'
gem 'momentjs-rails'
gem 'clipboard-rails'
gem 'google-api-client', '~> 0.8'
gem 'google_calendar'

# Use Gon gem to make data accessible in JS
gem 'gon'
