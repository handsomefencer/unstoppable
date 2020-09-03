require 'yaml'
module Roro
  class Configurator < Thor::Shell::Basic
    
    attr_reader :choices, :structure, :thor_actions, :env, :options
      
    def get_story(filename) 
      story_directory = File.dirname(__FILE__) + '/configurators/'
      YAML.load_file(story_directory + 'roro.yml')
    end
    
    def initialize(options={}) 
      @options = options || {}
      @structure = get_story('roro.yml') 
      @structure['story'] = @options['story'] || 'rails'
      roro_configurator =  Dir.pwd + '/roro_configurator.yml' 
      if File.exist?(roro_configurator)
        curation = YAML.load_file(roro_configurator)
        
        @structure['story'] = curation['story']
        unless @structure['story'].eql?(options['story'])
          msg = 'Story in roro_configurator.yml incompatible'
          raise(Roro::Error.new(msg + "\n\n"))
        end 
        # roro_configurator = YAML.load_file(Dir.pwd + '/roro_configurator.yml')
      end
      # story = YAML.load_file(File.dirname(__FILE__) + '/configurators/roro.yml')
       
      # base = YAML.load_file(File.dirname(__FILE__) + '/configurators/roro.yml')
      # @deployer = base 
      
      # byebug
      # story = roro_configurator ? roro_configurator : {}
      
      # @deployer = YAML.load_file(Dir.pwd + '/roro_configurator.yml')
      # @deployer = get_deployer 
      # @master = YAML.load_file(File.dirname(__FILE__) + '/roro_configurator.yml')
      # @master['services']['server_app']['vendors']['rails']['version'] = `ruby -v`.scan(/\d.\d/).first
      # @choices = @master['services']['server_app']['vendors']['rails']['choices'] 
      # @app = {} 
      # @thor_actions = {}
      # configure
      # roro_configurator =  Dir.pwd + '/roro_configurator.yml' 
      # preconfigured = File.exist?(roro_configurator)
      # base = YAML.load_file(File.dirname(__FILE__) + '/configurators/roro.yml')
      # @deployer = base 
      @configuration

    end
  end
end