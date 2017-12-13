require 'coveralls'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
Coveralls.wear_merged! 'rails'
# https://coveralls.zendesk.com/hc/en-us/articles/201769485-Ruby-Rails
