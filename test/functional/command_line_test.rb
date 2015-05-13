require 'test_helper'

class CommandLineWriteTest < Pigtail::TestCase
  setup do
    File.expects(:exists?).with('config/pigtail.rb').returns(true)
    @command    = Pigtail::CommandLine.new({ :write => true, :identifier => 'My identifier' })
    @configures = { path: "#{foobar_directory}", configure: "/my/command" }
    Pigtail.expects(:configs).returns(@configures)
  end
  should "output the pigtail config with identifier blocks" do
    output = @configures[:configure]
    assert_equal output, @command.send(:pigtail_configs)[:configure]
  end
  should "write the crontab when run" do
    @command.expects(:write_pigtail_config).returns(true)
    assert @command.run
  end
end

class ConfigTypeWithSetOptionTest < Pigtail::TestCase
  setup do
    @output = Pigtail.configs :string => \
    <<-file
      yaml = <<-YAML
- global:
    env: :env
    path: /foo/baz
      YAML
      config_type :yaml, yaml
      to "/foo/bar" do
        yaml "", { env: "ENV" }
      end
    file
  end
  should "output the runner using the override environment" do
    assert_equal([{ path: foobar_directory, configure: %(- global:\n    env: ENV\n    path: /foo/baz\n) }], @output)
  end
end
