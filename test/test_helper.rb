require 'pigtail'
require 'test_case'
require 'mocha/setup'

module Pigtail::TestHelpers
  protected
    def new_config(options={})
      Pigtail::Config.new(options)
    end

    def foobar_directory
      "/foo/bar"
    end
end

Pigtail::TestCase.send(:include, Pigtail::TestHelpers)
