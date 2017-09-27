require "yaml"
require "yqr/version"

module Yqr
  @yaml = nil
  @options = {debug: false, json: false, symborize: true, raw: false}

  class << self
    def yaml
      @yaml
    end

    def options
      @options
    end

    def load_str(str)
      @yaml = symbolize_all_keys YAML.load(str)
    end

    def load_file(file)
      @yaml = symbolize_all_keys YAML.load_file(file)
    end

    def symbolize_all_keys(obj)
      unless enable_symborize
        return obj
      end
      case obj.class.to_s
      when 'Hash'
        obj.keys.each do |key|
          obj[(key.to_sym rescue key) || key] = symbolize_all_keys(obj.delete(key))
        end
        obj
      when 'Array'
        obj.map! do |elem|
          symbolize_all_keys elem
        end
        obj
      else
        obj
      end
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

      if @options[:raw]
        return raw_output_formatter(obj)
      end

      if obj.class.to_s == "Array" || obj.class.to_s == "Hash"
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

    def raw_output_formatter(obj)
      obj
    end

    def parse_query
      if enable_symborize
        @options[:query].gsub(/\[(\w*)\]/, '[:\1]').gsub(/\[:(\d*)\]/, '[\1]')
      else
        @options[:query]
      end
    end

    def enable_symborize
      @options[:symborize]
    end

    def debug
      @options[:debug]
    end
  end
end
