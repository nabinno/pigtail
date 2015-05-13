Pigtail is a Ruby gem that provides a clear syntax for writing configurations.

### Installation

```sh
$ gem install pigtail
```

Or with Bundler in your Gemfile.

```ruby
gem 'pigtail'
```

### Getting started

```sh
$ cd /apps/my-great-project
$ pigtailize .
```

This will create an initial `config/pigtail.rb` file for you.

### Example config/pigtail.rb file

Pigtail ships with three pre-defined job types: command, runner, and rake. You can define your own with `config_type`.

```ruby
config_type :sports, <<-YAML
global:
  - category: :task
    place: :place
    log: :log
    feeds:
      - http://www.example.com/ski_1.rss
      - http://www.example.com/ski_2.rss
YAML
set :log, "/path/to/my/sports.log"

to "foo/bar" do
  sports "ski", {
    place: "/japan/nagano"
  }
end
```

Would configure `global: foo` to "/bar/buzz". `:task` is always replaced with the first argument, and any additional hash arguments are replaced with the options passed in or by variables that have been defined with `set`.

### The `pigtail` command

```sh
$ cd /apps/my-great-project
$ pigtail
```

This will simply show you your `config/pigtail.rb` file converted to cron syntax. It does not read or write your crontab file. Run `pigtail --help` for a complete list of options.

### Acknowledgement

Pigtail is based heavily on Whenever.

----

Compatible with Ruby 1.8.7-2.2.0, JRuby, and Rubinius. [![Build Status](https://secure.travis-ci.org/nabinno/pigtail.png)](http://travis-ci.org/nabinno/pigtail)

---

Copyright &copy; 2015 Nab Inno

----

A whale!
Down it goes, and more, and more
Up goes its tail!

-Buson Yosa
