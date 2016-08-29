source 'https://rubygems.org'

gem 'coveralls', :require => false
gem 'simplecov', :require => false

gem 'rails', '~> 3.2.22'
if RUBY_VERSION < "2.2.0"
  gem 'rack', '<= 1.6.0'
end

gemspec :path => '..'