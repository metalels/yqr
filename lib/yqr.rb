require "yaml"
require "yqr/version"

module Yqr
  @yaml = nil
  @options = {debug: false, json: false}

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
      STDERR.puts "Error was happen."
      STDERR.print ex.message
    end

    def exec_with_format
      obj = exec
      if debug
        puts "==== Object Info ===="
        puts obj.class
        puts obj
        puts "====================="
      end
      case obj.class.to_s
      #when "String", "Integer", "Float", "NilClass", "Time", "Date", "DateTime"
      #  obj
      #else
      when "Array", "Hash"
        if @options[:json]
          require 'json'
          obj.to_json
        else
          obj.to_yaml
        end
      else
        obj
      end
    end

    def parse_query
      @options[:query].gsub(/\[(\w*)\]/, '["\1"]').gsub(/\["(\d*)"\]/, '[\1]')
    end

    def debug
      @options[:debug]
    end
  end
end
