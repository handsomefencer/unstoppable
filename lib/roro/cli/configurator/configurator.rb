require 'yaml'
require 'json'
module Roro
  class Configurator < Thor::Shell::Basic
    
    attr_reader :choices, :structure, :intentions, :env, :options

    def initialize(options)
      options ||= {}
      options[:story] ||=  { rails: {} } 
      sanitize(options)
      @structure = {
        choices:    {},
        env_vars:   {},
        intentions: {} 
      }
      build_layers(stories: @options[:story])
      @env = @structure[:env_vars]
      @env[:main_app_name] = Dir.pwd.split('/').last 
      @env[:ruby_version] = `ruby -v`.scan(/\d.\d/).first
      screen_target_directory 
    end
    
    def build_layers(story, location=nil)
      story.each do |key, value| 
        location = location ? (location + '/' + key.to_s ) : key.to_s
        filedir = File.dirname(__FILE__) + "/#{location}"
        filepath = "#{filedir}.yml"
        case 
        when File.exist?(filepath)
          layer = get_layer(filepath) 
          overlay(layer) unless layer.nil?
        when !File.exist?(filedir)
          error_msg = 'Cannot find that story. Has it been written?' 
          raise (Roro::Error.new(error_msg)) 
        end
        if value.is_a?(Array)
          value.each {|v| build_layers(v, location) }
        else 
          build_layers(value, location) 
        end 
      end 
    end 
    
    def overlay(layer)
      layer.each do |key, value|
        @structure[key] ||= {}
        @structure[key] = @structure[key].merge!(value)
      end
      return if layer[:choices].nil?
      layer[:choices].each do |key, value|
        @structure[:intentions][key] ||= {}
        @structure[:intentions][key] = value[:default]  
      end 
    end

    private 

    def get_layer(filepath) 
      JSON.parse(YAML.load_file(filepath).to_json, symbolize_names: true)
    end

    def screen_target_directory
      if options[:greenfield]
        confirm_directory_empty
      else 
        confirm_directory_app
      end
      handle_roro_artifacts
    end
    
    def sanitize(options)
      options.each do |k, v| 
        case v
        when Array
          v.each { |vs| sanitize(vs) }
        when Hash 
          sanitize(v)
        when true 
          options[k] = {}
        when
          options[k] = { v.to_sym => {}} 
        end
      end
      @options = options
    end
  end
end