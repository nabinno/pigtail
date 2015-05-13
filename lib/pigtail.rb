require 'pigtail/configs'
require 'pigtail/config'
require 'pigtail/command_line'
require 'pigtail/output_config'
require 'pigtail/version'

module Pigtail
  def self.configs(options)
    Pigtail::Configs.new(options).generate_configs_output
  end

  def self.path
    Dir.pwd
  end
end
