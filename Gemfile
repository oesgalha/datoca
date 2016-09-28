source 'https://rubygems.org'

gem 'rails', '~> 5.0'

# =================================
# Database and ActiveRecord plugins
# =================================
gem 'pg', '~> 0.18'
gem 'refile', github: 'refile/refile', require: 'refile/rails'
gem 'refile-mini_magick', github: 'refile/refile-mini_magick'
gem 'sinatra', github: 'sinatra/sinatra', branch: 'master'      # Refile dependecies see: https://github.com/refile/refile/issues/447
gem 'ransack', '~> 1.8'
gem 'scenic', '~> 1.3'

# =================================
# Authentication and Authorization
# =================================
gem 'devise', '~> 4.2'
gem 'pundit', '~> 1.1'

# =================================
# Content
# =================================
gem 'high_voltage', '~> 3.0'
gem 'rails-i18n', '~> 5.0'
gem 'redcarpet', '~> 3.3'
gem 'devise-i18n', '~> 1.1'

# =================================
# Webserver
# =================================
gem 'puma', '~> 3.6'

# =================================
# Forms and Views
# =================================
gem 'nested_form', '~> 0.3'

# =================================
# Assets
# =================================
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
source 'https://rails-assets.org' do
  gem 'rails-assets-bulma', '~> 0.2'
  gem 'rails-assets-chosen', '~> 1.6'
  gem 'rails-assets-fontawesome', '~> 4.6'
  gem 'rails-assets-markdown-js', '~> 0.6'
end

# =================================
# ⚡️  M A D  M A T H  S T U F F  ⚡️
# =================================
gem 'daru', '~> 0.1'

# =================================
# Development tools
# =================================
group :development do
  gem 'pry', '~> 0.10'
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 1.7'
  gem 'annotate', '~> 2.7'
  gem 'rack-mini-profiler', '~> 0.10', require: false
end

# =================================
# Testing libs
# =================================
group :test do
  gem 'laranja', '~> 2.0'
end
