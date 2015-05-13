module Pigtail
  module Output
    class Config
      attr_accessor :path, :configure

      def initialize(path = nil, configure = nil)
        @path      = path
        @configure = configure
      end

      def self.enumerate(item)
        if item and item.is_a?(String)
          items = item.split(',')
        else
          items = item
          items = [items] unless items and items.respond_to?(:each)
        end
        items
      end

      def self.output(paths, config)
        enumerate(paths).each do |path|
          yield new(path, config.output).output
        end
      end

      def output
        { path: @path, configure: @configure }
      end
    end
  end
end
