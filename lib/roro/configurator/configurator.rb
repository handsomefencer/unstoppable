require 'yaml'
require 'json'
module Roro
  class Configurator < Thor::Shell::Basic
    
    attr_reader :structure, :intentions, :env, :options, :actions

    def initialize(options=nil)
      options ||= {}
      options[:story] ||=  { rails: {} } 
      sanitize(options)
      @structure = {
        choices:    {},
        env_vars:   {},
        intentions: {}, 
        story:      {} 
      }
      build_layers(rollon: @options[:story])
      @intentions = @structure[:intentions]
      @env = @structure[:env_vars]
      @env[:main_app_name] = Dir.pwd.split('/').last 
      @env[:ruby_version] = `ruby -v`.scan(/\d.\d/).first
      screen_target_directory 
    end
    
    def build_layers(story, location=nil)
      story.each do |key, value| 
        location = location ? (location + '/' + key.to_s ) : key.to_s
        filedir = Roro::CLI.story_root + "/#{location}"
        filepath = "#{filedir}.yml"
        case 
        when File.exist?(filepath)
          layer = get_layer(filepath) 
          overlay(layer) unless layer.nil?
        when !File.exist?(filedir)
          error_msg = "Cannot find that story #{key} at #{filepath}. Has it been written?" 
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

      layer.each { |key, value| @structure[key] ||= value }
              
      overlay_choices(layer) if layer[:choices]
      overlay_env_vars(layer) if layer[:env_vars]
      overlay_actions(layer) if layer[:actions]
    end
    
    def overlay_actions(layer)
      @structure[:actions].concat(layer[:actions]) 
    end
    
    def overlay_env_vars(layer) 
      layer[:env_vars].each do |key, value| 
        @structure[:env_vars][key] = value
      end    
    end

    def overlay_choices(layer)
      layer[:choices].each do |key, value|
        @structure[:choices][key] = value
        @structure[:intentions][key] = value[:default]  
      end
    end

    private 

    def get_layer(filepath) 
      json = JSON.parse(YAML.load_file(filepath).to_json, symbolize_names: true)
      json ? json : ( raise (Roro::Error.new(error_msg))) 
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
      options.transform_keys!{|k| k.to_sym}
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