require 'test_helper'

class ConfigTest < Pigtail::TestCase
  should "substitute the :task when #output is called" do
    config = new_config(:template => ":task", :task => 'abc123')
    assert_equal 'abc123', config.output
  end

  should "substitute the :path when #output is called" do
    assert_equal 'foo', new_config(:template => ':path', :path => 'foo').output
  end

  should "not substitute parameters for which no value is set" do
    assert_equal 'Hello :world', new_config(:template => ':matching :world', :matching => 'Hello').output
  end

  should "escape percent signs" do
    config = new_config(
      :template => "before :foo after",
      :foo => "percent -> % <- percent"
    )
    assert_equal %q(before percent -> \% <- percent after), config.output
  end

  should "assume percent signs are not already escaped" do
    config = new_config(
      :template => "before :foo after",
      :foo => %q(percent preceded by a backslash -> \% <-)
    )
    assert_equal %q(before percent preceded by a backslash -> \\\% <- after), config.output
  end
end

class ConfigWithQuotesTest < Pigtail::TestCase
  should "output the :task if it's in single quotes" do
    config = new_config(:template => "':task'", :task => 'abc123')
    assert_equal %q('abc123'), config.output
  end

  should "output the :task if it's in double quotes" do
    config = new_config(:template => '":task"', :task => 'abc123')
    assert_equal %q("abc123"), config.output
  end

  should "output escaped single quotes in when it's wrapped in them" do
    config = new_config(
      :template => "before ':foo' after",
      :foo => "quote -> ' <- quote"
    )
    assert_equal %q(before 'quote -> '\'' <- quote' after), config.output
  end

  should "output escaped double quotes when it's wrapped in them" do
    config = new_config(
      :template => 'before ":foo" after',
      :foo => 'quote -> " <- quote'
    )
    assert_equal %q(before "quote -> \" <- quote" after), config.output
  end
end

class ConfigWithConfigTemplateTest < Pigtail::TestCase
  should "use the config template" do
    config = new_config(:template => ':task', :task => 'abc123', :config_template => 'left :config right')
    assert_equal 'left abc123 right', config.output
  end

  should "reuse parameter in the config template" do
    config = new_config(:template => ':path :task', :path => 'path', :task => "abc123", :config_template => ':path left :config right')
    assert_equal 'path left path abc123 right', config.output
  end

  should "escape single quotes" do
    config = new_config(:template => "before ':task' after", :task => "quote -> ' <- quote", :config_template => "left ':config' right")
    assert_equal %q(left 'before '\''quote -> '\\''\\'\\'''\\'' <- quote'\'' after' right), config.output
  end

  should "escape double quotes" do
    config = new_config(:template => 'before ":task" after', :task => 'quote -> " <- quote', :config_template => 'left ":config" right')
    assert_equal %q(left "before \"quote -> \\\" <- quote\" after" right), config.output
  end
end
