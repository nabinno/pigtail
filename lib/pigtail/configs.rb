module Pigtail
  class Configs

    def initialize(options)
      @configs, @set_variables, @pre_set_variables = {}, {}, {}, {}

      if options.is_a? String
        options = { :string => options }
      end

      pre_set(options[:set])

      # setup_file     = File.expand_path('../setup.rb', __FILE__)
      # setup          = File.read(setup_file)
      pigtail_config =
        if options[:string]
          options[:string]
        elsif options[:file]
          File.read(options[:file])
        end

      # instance_eval(setup, setup_file)
      instance_eval(pigtail_config, options[:file] || '<eval>')
    end

    def set(variable, value)
      variable = variable.to_sym
      return if @pre_set_variables[variable]

      instance_variable_set("@#{variable}".to_sym, value)
      self.class.send(:attr_reader, variable.to_sym)
      @set_variables[variable] = value
    end

    def to(path, options = {})
      @current_path_scope = path
      @options = options
      yield
    end

    def config_type(name, template)
      singleton_class_shim.class_eval do
        define_method(name) do |task, *args|
          options = { :task => task, :template => template }
          options.merge!(args[0]) if args[0].is_a? Hash

          @configs[@current_path_scope] ||= []
          @configs[@current_path_scope] << Pigtail::Config.new(@options.merge(@set_variables).merge(options))
        end
      end
    end

    def generate_configs_output
      output_configs
    end

  private

    # The Object#singleton_class method only became available in MRI 1.9.2, so
    # we need this to maintain 1.8 compatibility. Once 1.8 support is dropped,
    # this can be removed
    def singleton_class_shim
      if self.respond_to?(:singleton_class)
        singleton_class
      else
        class << self; self; end
      end
    end

    #
    # Takes a string like: "variable1=something&variable2=somethingelse"
    # and breaks it into variable/value pairs. Used for setting variables at runtime from the command line.
    # Only works for setting values as strings.
    #
    def pre_set(variable_string = nil)
      return if variable_string.nil? || variable_string == ""

      pairs = variable_string.split('&')
      pairs.each do |pair|
        next unless pair.index('=')
        variable, value = *pair.split('=')
        unless variable.nil? || variable == "" || value.nil? || value == ""
          variable = variable.strip.to_sym
          set(variable, value.strip)
          @pre_set_variables[variable] = value
        end
      end
    end

    #
    # Takes the standard config output that Pigtail generates and finds
    # similar entries that can be combined. For example: If a configure should run
    # at "/foo/bar" and "/foo/baz", instead of creating two configures this method combines
    # them into one that runs at the 2nd, 3rd and 4th directory.
    #
    def combine(entries)
      entries.map! { |entry| entry.split(/ +/, 6) }
      0.upto(4) do |f|
        (entries.length-1).downto(1) do |i|
          next if entries[i][f] == '*'
          comparison = entries[i][0...f] + entries[i][f+1..-1]
          (i-1).downto(0) do |j|
            next if entries[j][f] == '*'
            if comparison == entries[j][0...f] + entries[j][f+1..-1]
              entries[j][f] += ',' + entries[i][f]
              entries.delete_at(i)
              break
            end
          end
        end
      end

      entries.map { |entry| entry.join(' ') }
    end

    def output_configs
      return if @configs.empty?

      @output_configs = []

      @configs.each do |paths, configs|
        configs.each do |config|
          Pigtail::Output::Config.output(paths, config) do |pigtail_config|
            @output_configs << pigtail_config
          end
        end
      end

      return @output_configs
    end
  end
end
