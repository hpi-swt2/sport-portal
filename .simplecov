require 'coveralls'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.add_filter 'lib/tasks/cucumber.rake'
SimpleCov.start('rails')
# https://coveralls.zendesk.com/hc/en-us/articles/201769485-Ruby-Rails
