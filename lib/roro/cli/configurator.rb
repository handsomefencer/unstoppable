require 'yaml'
module Roro
  class Configurator < Thor::Shell::Basic
    
    attr_reader :choices, :structure, :thor_actions, :env, :options
      
    def get_story(filename) 
      roro_configurator =  Dir.pwd + '/roro_configurator.yml' 
      if File.exist?(roro_configurator)
        curation = YAML.load_file(roro_configurator)
        msg = 'Story in roro_configurator.yml incompatible'
        if !curation['story'].eql?(@story) || get_story(@story)
          raise(Roro::Error.new(msg + "\n\n"))
        end 
      end

      story_directory = File.dirname(__FILE__) + '/configurators/'
      YAML.load_file(story_directory + filename + '.yml')
    end
    
    def initialize(options={}) 
      @options = options || {}
      story = options['story']
      case 
      when story.nil?
        @story = 'rails' 
      when options['story'].is_a?(String)
        @story = options['story']
      when options['story'].is_a?(Hash)
        @story = @options['story'].keys.first
      end
      # story = @options['story'] 
      # @story = (story.value.is_a?(Hash) ? story.keys.first : story ) #|| 'rails'
      # unless @options['story'].nil?
      #   byebug
      # end 
      # @story = @options['story'] || 'rails'
      # if options['story'] = { 'rails' => 'with_postgresql' }
      #   byebug 
      #   end      
      
      @structure = get_story('roro') 
      @structure['story'] = get_story(@story)
      @structure['choices'].merge!(@structure['story']['choices'])
      @structure['intentions'] = {}
      @structure['choices'].each do |key, value|
        @structure['intentions'][key] = value['default'] 
      end
      @env = @structure['env_vars']
      @env.merge!(@structure['registries']['docker']['env_vars'] )
      @env.merge!(@structure['ci_cd']['circleci']['env_vars'] )
      @env.merge!(@structure['deployment']['env_vars'] )
      @env.merge!(@structure['story']['env_vars'] )
      
    end
  end
end