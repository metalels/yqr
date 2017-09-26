require "yaml"
require "yqr/version"

module Yqr
  @yaml = nil
  @options = {debug: false}

  class << self
    def yaml
      @yaml
    end

    def options
      @options
    end

    def load_str(str)
      @yaml = YAML.load str
    end

    def load_file(file)
      @yaml = YAML.load_file file
    end

    def exec
      if debug
        puts "==== Query Info ===="
        puts %Q{self.yaml#{parse_query}}
        puts "==== Yaml Info ====="
        puts @yaml
        puts "===================="
      end

      eval %Q{self.yaml#{parse_query}}
    rescue => ex
      puts "Error was happen."
      print ex.message
    end

    def parse_query
      @options[:query].gsub(/\[(\w*)\]/, '["\1"]').gsub(/\["(\d*)"\]/, '[\1]')
    end

    def debug
      @options[:debug]
    end
  end
end
