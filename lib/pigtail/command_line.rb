require 'fileutils'

module Pigtail
  class CommandLine

    def self.execute(options={})
      new(options).run
    end

    def initialize(options={})
      @options                = options
      @options[:file]       ||= 'config/pigtail.rb'
      @options[:identifier] ||= default_identifier
      # @options[:cut]        ||= 0

      if !File.exists?(@options[:file]) && @options[:clear].nil?
        warn("[fail] Can't find file: #{@options[:file]}")
        exit(1)
      end

      # if [@options[:update], @options[:write], @options[:clear]].compact.length > 1
      #   warn("[fail] Can only update, write or clear. Choose one.")
      #   exit(1)
      # end

      # unless @options[:cut].to_s =~ /[0-9]*/
      #   warn("[fail] Can't cut negative lines from the pigtail_config #{options[:cut]}")
      #   exit(1)
      # end
      # @options[:cut] = @options[:cut].to_i
    end

    def run
      # if @options[:update] || @options[:clear]
      #   write_pigtail_config(updated_pigtail_config)
      # elsif @options[:write]
      if @options[:write]
        write_pigtail_config(pigtail_configs)
      else
        puts Pigtail.configs(@options)
        puts "## [message] Above is your pigtail_config file converted to config syntax; your pigtail_config file was not updated."
        puts "## [message] Run `pigtail --help' for more options."
        exit(0)
      end
    end

  protected

    def default_identifier
      File.expand_path(@options[:file])
    end

    def pigtail_configs
      # return '' if @options[:clear]
      Pigtail.configs(@options)
    end

    # def read_pigtail_config
    #   return @current_pigtail_config if @current_pigtail_config
    #   @current_pigtail_config = ""
    #   # @current_pigtail_config = pigtail_configs.nil? ? '' : prepare(pigtail_configs)
    # end

    def write_pigtail_config(contents)
      contents.each do |content|
        content_path      = content[:path]
        content_configure = content[:configure]
        system("mkdir -p " + File.dirname(content_path))
        IO.popen("cat >" + content_path, 'r+') do |io|
          configure = ([comment_open, content_configure, comment_close].compact.join("\n") + "\n")
          io.write(configure)
          io.close_write
        end

        success = $?.exitstatus.zero?

        if success
          action = 'written' if @options[:write]
          # action = 'updated' if @options[:update]
          puts "[write] pigtail file #{action} to #{content_path}"
        else
          warn "[fail] Couldn't write pigtail to #{content_path}; try running `pigtail' with no options to ensure your config file is valid."
        end
      end
    end

    # def updated_pigtail_config
    #   # Check for unopened or unclosed identifier blocks
    #   if (read_pigtail_config =~ Regexp.new("^#{comment_open}\s*$") &&
    #       (read_pigtail_config =~ Regexp.new("^#{comment_close}\s*$")).nil?)
    #     warn "[fail] Unclosed indentifier; Your pigtail_config file contains '#{comment_open}', but no '#{comment_close}'"
    #     exit(1)
    #   elsif ((read_pigtail_config =~ Regexp.new("^#{comment_open}\s*$")).nil? &&
    #          read_pigtail_config =~ Regexp.new("^#{comment_close}\s*$"))
    #     warn "[fail] Unopened indentifier; Your pigtail_config file contains '#{comment_close}', but no '#{comment_open}'"
    #     exit(1)
    #   end
    #
    #   # If an existing identier block is found, replace it with the new pigtail config entries
    #   if (read_pigtail_config =~ Regexp.new("^#{comment_open}\s*$") &&
    #       read_pigtail_config =~ Regexp.new("^#{comment_close}\s*$"))
    #     # If the existing pigtail_config file contains backslashes they get lost going through gsub.
    #     # .gsub('\\', '\\\\\\') preserves them. Go figure.
    #     read_pigtail_config.gsub(Regexp.new("^#{comment_open}\s*$.+^#{comment_close}\s*$", Regexp::MULTILINE),
    #                              pigtail_configs[:configure].chomp.gsub('\\', '\\\\\\'))
    #   else # Otherwise, append the new pigtail config entries after any existing ones
    #     [read_pigtail_config, pigtail_configs].join("\n\n")
    #   end.gsub(/\n{3,}/, "\n\n") # More than two newlines becomes just two.
    # end

    # def prepare(contents)
    #   # Strip n lines from the top of the file as specified by the :cut option.
    #   # Use split with a -1 limit option to ensure the join is able to rebuild
    #   # the file with all of the original seperators in-tact.
    #   stripped_contents = contents.split($/,-1)[@options[:cut]..-1].join($/)
    #
    #   # Some pigtail config implementations require all non-comment lines to be newline-
    #   # terminated. (issue #95) Strip all newlines and replace with the default
    #   # platform record seperator ($/)
    #   stripped_contents.gsub!(/\s+$/, $/)
    # end

    def comment_base
      "Pigtail generated configures for: #{@options[:identifier]}"
    end

    def comment_open
      "# Begin #{comment_base}"
    end

    def comment_close
      "# End #{comment_base}"
    end
  end
end
