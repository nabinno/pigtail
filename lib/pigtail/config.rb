# require 'shellwords'

module Pigtail
  class Config

    def initialize(options = {})
      @options = options
      @template                         = options.delete(:template)
      @config_template                  = options.delete(:config_template) || ":config"
      # @options[:environment_variable] ||= "RAILS_ENV"
      # @options[:environment]          ||= :production
      # @options[:path]                   = Shellwords.shellescape(@options[:path] || Pigtail.path)
    end

    def output
      config = process_template(@template, @options)
      out = process_template(@config_template, @options.merge(:config => config))
      out.gsub(/%/, '\%')
    end

  protected

    def process_template(template, options)
      template.to_s.gsub(/:\w+/) do |key|
        before_and_after = [$`[-1..-1], $'[0..0]]
        option = options[key.sub(':', '').to_sym] || key

        if before_and_after.all? { |c| c == "'" }
          escape_single_quotes(option)
        elsif before_and_after.all? { |c| c == '"' }
          escape_double_quotes(option)
        else
          option
        end
      end
      # end.gsub(/\s+/m, " ").strip
    end

    def escape_single_quotes(str)
      str.gsub(/'/) { "'\\''" }
    end

    def escape_double_quotes(str)
      str.gsub(/"/) { '\"' }
    end
  end
end
