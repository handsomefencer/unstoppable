require 'yaml'
module Roro
  class Configurator < Thor::Shell::Basic
    
    attr_reader :choices, :structure, :intentions, :env

    def initialize(opts=nil, story=nil)
      story = (opts && opts['story']) ? opts['story'] : { 'rails'=> {} }   
      story = story.is_a?(String) ? { story => {} } : story
      @structure = {
        'intentions' => {},
        'choices' =>    {},
        'env_vars' =>   {},
        'story' =>      { 'stories' => story } }
      build_layers(@structure['story'])
      @intentions = @structure['intentions']
      @env = @structure['env_vars']
      @env['main_app_name'] = Dir.pwd.split('/').last 
      @env['ruby_version'] = `ruby -v`.scan(/\d.\d/).first 

    end

    def build_layers(story, location='')
      story = { story => {} } if story.is_a?(String)
      story.each do |key, value|
        new_location = location + '/' + key
        layer = get_layer(new_location)
        merge_layer_on_top(layer) if layer
        build_layers(value, new_location)  
      end
    end
    
    def merge_layer_on_top(layer)
      merge_intentions_on_top(layer) 
      layer.each do |key, value|
        next if key.eql?('story')
        hash = @structure[key] ? @structure[key] : {}
        @structure[key] = hash.merge!(value)
      end
    end
    
    def merge_intentions_on_top(layer) 
      unless layer['choices'].nil?
        layer['choices'].each do |key, value|
          @structure['intentions'][key] = value['default'] 
        end 
      end
    end
    
    def get_layer(filename) 
      error_msg = 'Story in roro_configurator.yml incompatible'
      filedir = File.dirname(__FILE__) + "/configurator/#{filename}"
      filepath = "#{filedir}.yml"
      unless File.exist?(filedir) || File.exist?(filepath)
        raise (Roro::Error.new(error_msg)) 
      end 
      File.exist?(filepath) ? YAML.load_file(filepath) : false
    end
    
   
      # roro_configurator =  Dir.pwd + '/roro_configurator.yml' 

      # if File.exist?(roro_configurator)
      #   curation = YAML.load_file(roro_configurator)
      #   if !curation['story'].eql?(@story) || get_story(@story)
      #     raise(Roro::Error.new(msg + "\n\n"))
      #   end 
      # end

      # @structure = get_story('roro') 
      # @structure['story'] = get_story(@story)
      # @structure['choices'].merge!(@structure['story']['choices'])
      # @structure['intentions'] = {}
      # @structure['choices'].each do |key, value|
      #   @structure['intentions'][key] = value['default'] 
      # end
      # @env = @structure['env_vars']
      # @env.merge!(@structure['registries']['docker']['env_vars'] )
      # @env.merge!(@structure['ci_cd']['circleci']['env_vars'] )
      # @env.merge!(@structure['deployment']['env_vars'] )
      # @env.merge!(@structure['story']['env_vars'] )
      
  end
end