require 'test_helper'

class OutputDefinedConfigTest < Pigtail::TestCase
  test "defined config with a :task" do
    output = Pigtail.configs \
    <<-file
      set :config_template, nil
      config_type :some_config, "before :task after"
      to "/foo/bar" do
        some_config "during"
      end
    file

    assert_equal([{ path: "/foo/bar", configure: "before during after" }], output)
  end

  test "defined config with a :task and some options" do
    output = Pigtail.configs \
    <<-file
      set :config_template, nil
      config_type :some_config, "before :task after :option1 :option2"
      to "/foo/bar" do
        some_config "during", :option1 => 'happy', :option2 => 'birthday'
      end
    file

    assert_equal([{ path: "/foo/bar", configure: "before during after happy birthday" }], output)
  end

  test "defined config with a :task and an option where the option is set globally" do
    output = Pigtail.configs \
    <<-file
      set :config_template, nil
      config_type :some_config, "before :task after :option1"
      set :option1, 'happy'
      to "/foo/bar" do
        some_config "during"
      end
    file

    assert_equal([{ path: "/foo/bar", configure: "before during after happy" }], output)
  end

  test "defined config with a :task and an option where the option is set globally and locally" do
    output = Pigtail.configs \
    <<-file
      set :config_template, nil
      config_type :some_config, "before :task after :option1"
      set :option1, 'global'
      to "/foo/bar" do
        some_config "during", :option1 => 'local'
      end
    file

    assert_equal([{ path: "/foo/bar", configure: "before during after local" }], output)
  end

  test "defined config with a :task and an option that is not set" do
    output = Pigtail.configs \
    <<-file
      set :config_template, nil
      config_type :some_config, "before :task after :option1"
      to "/foo/bar" do
        some_config "during", :option2 => 'happy'
      end
    file

    assert_equal([{ path: "/foo/bar", configure: "before during after :option1" }], output)
  end
end
