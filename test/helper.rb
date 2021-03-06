begin
  require 'rack'
rescue LoadError
  require 'rubygems'
  require 'rack'
end

libdir = File.dirname(File.dirname(__FILE__)) + '/lib'
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include?(libdir)

require 'sinatra/base'
require 'sinatra/test/unit'

module Sinatra::Test
  # Sets up a Sinatra::Base subclass defined with the block
  # given. Used in setup or individual spec methods to establish
  # the application.
  def mock_app(base=Sinatra::Base, &block)
    @app = Sinatra.new(base, &block)
  end
end

class Sinatra::Base
  # Allow assertions in request context
  include Test::Unit::Assertions
end

##
# test/spec/mini
# http://pastie.caboo.se/158871
# chris@ozmm.org
#
def describe(*args, &block)
  return super unless (name = args.first) && block
  klass = Class.new(Test::Unit::TestCase) do
    def self.it(name, &block)
      define_method("test_#{name.gsub(/\W/,'_')}", &block)
    end
    def self.xspecify(*args) end
    def self.before(&block) define_method(:setup, &block)    end
    def self.after(&block)  define_method(:teardown, &block) end
  end
  klass.class_eval &block
end
