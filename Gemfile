source 'https://rubygems.org'

gem 'nanoc', '~> 4.0'
gem 'kramdown', '~> 1.4.1'
gem 'asciidoc', '~> 0.0.2'
gem 'pygments.rb', '~> 0.6.3'
# gem 'nanoc-toolbox', '~> 0.2.0'
gem 'builder', '~> 3.2.2'
# gem 'nanoc-core'
# gem 'nanoc-breadcrumbs', :git => 'https://github.com/nanoc/nanoc-breadcrumbs', :branch => 'master'
#gem 'nanoc-asciidoc'


## Special logic for eventmachine, a dependency which doesn't behave well
#
# on OSX, we need a specific version of eventmachine, but that version won't
# work on Linux
# As of 2015-11-02, the latest version of eventmachine compiles on Linux, but
# eventmachine 1.0.3 is the only known version that works on OSX, so we must
# peg to that version when we're on an OSX box
case RUBY_PLATFORM
when /darwin/
  gem 'eventmachine', '= 1.0.3'
when /linux/
  gem 'eventmachine', '~> 1.0.8'
end
## end special logic

group :development do
	gem 'guard-nanoc', '~> 1.0.2'
	gem 'guard', '~> 2.6.1'
  gem 'adsf', '~> 1.2.0'
	gem 'nokogiri', '~> 1.6.3.1'
  gem 'w3c_validators', '~> 1.2'
  gem 'guard-livereload', '~> 2.3.0', require: false
end
