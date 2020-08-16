module Roro
  class Configuration 
    
    attr_reader :master, :app, :choices, :thor_actions
      
    def initialize 
      @master = YAML.load_file(File.dirname(__FILE__) + '/roro_configurator.yml')
      @master['services']['server_app']['vendors']['rails']['version'] = `ruby -v`.scan(/\d.\d/).first
      @services = @master['services']
      @app = {}
      @choices = @master['services']['server_app']['vendors']['rails']['choices'] 
      @thor_actions = {}
    end
    
  #   case 
  #   when File.exist?('.roro_config.yml')
  #     @config = Roro::Configuration.new 
  #     @config.set_from_config# puts 'no roro config file' 
  #     YAML.load_file(Dir.pwd + '/.roro_config.yml') || false

  #   when @config.nil? 
  #     @config = Roro::Configuration.new 
  #     @config.set_from_defaults
  #   end
  #   @config
  # end
    
    def set_app_variables_from_defaults 
      @app = {
        'main_app_name' =>             Dir.pwd.split('/').last,
        'database_host' =>        @services['server_app']['vendors']['rails']['env_vars']['DATABASE_HOST'],
        'ruby_version' =>         @services['server_app']['vendors']['rails']['version'],
        'frontend_service' =>   @services['frontend']['name'],
        'webserver_service' =>    @services['webserver']['default'],
        'database_service' =>     @services['database']['name'],
        'database_vendor' =>      @services['database']['vendor'],
      }
    end 
    
    def set_from_defaults 
      set_app_variables_from_defaults
      set_thor_actions_from_defaults
    end
    
    def set_thor_actions_from_defaults
      @choices.each { |key, value| @thor_actions[key] = value["default"] } 
    end
    
    def set_from_roro_config
      set_from_defaults 
      yaml = YAML.load_file(Dir.pwd + '/.roro_config.yml')
      yaml.each { |key, value| @app[key] = value }
      yaml['thor_actions'].each do |key, value| 
        @thor_actions[key] = value 
      end 
    end
  end
end