ROOT = File.expand_path('..', File.dirname(__FILE__))

$:.unshift "#{ROOT}/lib"

require 'minitest/spec'
require 'red_pandas'
