module Roro
  class Configuration < Thor
    
    attr_reader :master, :app, :choices, :thor_actions
      
    def initialize(options={}) 
      @options = options || {}
      @master = YAML.load_file(File.dirname(__FILE__) + '/roro_configurator.yml')
      @master['services']['server_app']['vendors']['rails']['version'] = `ruby -v`.scan(/\d.\d/).first
      @choices = @master['services']['server_app']['vendors']['rails']['choices'] 
      @app = {} 
      @thor_actions = {}
      configure
    end
    
    def configure
      set_from_defaults 
      case 
      when @options['interactive'] && File.exist?('.roro_config.yml')
        set_from_roro_config
        set_from_interactive
      when File.exist?('.roro_config.yml') 
        set_from_roro_config
      when @options['interactive']
        set_from_interactive
      end
    end
    
    def set_from_defaults 
      svcs = @master['services']
      rails = svcs['server_app']['vendors']['rails']
      @app = {
        'main_app_name' =>        Dir.pwd.split('/').last,
        'database_host' =>        rails['env_vars']['DATABASE_HOST'],
        'ruby_version' =>         rails['version'],
        'frontend_service' =>     svcs['frontend']['name'],
        'webserver_service' =>    svcs['webserver']['default'],
        'database_service' =>     svcs['database']['name'],
        'database_vendor' =>      svcs['database']['vendor'],
      } 
      @choices.each { |key, value| @thor_actions[key] = value["default"] }
    end
    
    def set_from_roro_config
      yaml = YAML.load_file(Dir.pwd + '/.roro_config.yml')
      yaml.each { |key, value| @app[key] = value }
      if yaml['thor_actions'] 
        yaml['thor_actions'].each do |key, value| 
          @thor_actions[key] = value
        end 
      end 
    end
    
    def set_from_interactive 
      @choices.each do |key, v|
        # byebug
        answer = ask(v['question'], default: v['default'], choices: v['choices'] )
        @thor_actions[key] = answer
      end
    end
  end
end