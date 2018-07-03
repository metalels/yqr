require "yaml"
require "yqr/version"

begin
  require "hashie"
rescue LoadError
  # do nothing
end

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

    def load_yaml
      if @options[:file]
        load_file
      else
        load_body
      end
      symbolize_all_keys @yaml
    end

    def load_body
      @yaml = if enable_symborize && Module.constants.include?(:Hashie)
        load_body_use_hashie @options[:body]
      else
        YAML.load @options[:body]
      end
    end

    def load_file
      @yaml = if enable_symborize && Module.constants.include?(:Hashie)
        load_yaml_use_hashie @options[:file]
      else
        YAML.load_file @options[:file]
      end
    end

    def load_body_use_hashie(body)
      tmp_file_path = "/tmp/yqr_tmp.#{Time.now.to_i}"
      File.write tmp_file_path, body
      load_yaml_use_hashie tmp_file_path, true
    end

    def load_yaml_use_hashie(path, delete=false)
      begin
        Hashie::Mash.load path
      rescue => ex
        if debug
          puts ex.message
        end
        YAML.load_file path
      ensure
        if delete && File.exist?(path)
          File.delete path
        end
      end
    end

    def symbolize_all_keys(obj)
      return obj unless enable_symborize
      case obj.class.to_s
      when 'Hash'
        if Module.constants.include?(:Hashie)
          obj = Hashie::Mash.new(obj)
        else
          obj.keys.each do |key|
            obj[(key.to_sym rescue key) || key] = symbolize_all_keys(obj.delete(key))
          end
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

    def result_decode(obj)
      return obj unless enable_symborize
      case obj.class.to_s
      when 'Hash'
        obj.keys.each do |key|
          obj[(key.to_sym rescue key) || key] = result_decode(obj.delete(key))
        end
        obj
      when 'Array'
        obj.map! do |elem|
          result_decode elem
        end
        obj
      when 'Hashie::Mash'
        result_decode obj.to_h
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

      case parse_query
      when /\A(\w|\d)/
        raise "<QUERY> format is invalid."
      end

      eval %Q{self.yaml#{parse_query}}
    rescue => ex
      STDERR.puts "Error was happen."
      STDERR.print ex.message
    end

    def exec_with_format
      load_yaml
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

      obj = result_decode obj

      case obj.class.to_s
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

    def raw_output_formatter(obj)
      obj.inspect
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
