require 'coveralls'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start('rails')
# https://coveralls.zendesk.com/hc/en-us/articles/201769485-Ruby-Rails
