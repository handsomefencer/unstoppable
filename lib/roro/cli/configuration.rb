module Roro
  class Configuration 
    
    attr_reader :master, :app, :choices, :thor_actions
      
    def initialize 
      @master = YAML.load_file(File.dirname(__FILE__) + '/roro_configurator.yml')
      @master['services']['server_app']['vendors']['rails']['version'] = `ruby -v`.scan(/\d.\d/).first
      @services = @master['services']
      @registry = @master['registries']['dockerhub']
      @app = {}
      @choices = @master['services']['server_app']['vendors']['rails']['choices'] 
      @thor_actions = {}
    end
    
    def set_app_variables_from_defaults 
      @app = {
        'app_name' =>             Dir.pwd.split('/').last,
        'deployment_image_tag' => @master['ci_cd']['circleci']['env_vars']['DEPLOY_TAG'], 
        'dockerhub_email' =>      @registry['env_vars']['DOCKERHUB_EMAIL'],
        'dockerhub_org' =>        @registry['env_vars']['DOCKERHUB_ORG'],
        'dockerhub_user' =>       @registry['env_vars']['DOCKERHUB_USER'],
        'dockerhub_password' =>   @registry['env_vars']['DOCKERHUB_PASSWORD'],
        
        'database_host' =>        @services['server_app']['vendors']['rails']['env_vars']['DATABASE_HOST'],
        'ruby_version' =>         @services['server_app']['vendors']['rails']['version'],
        'frontend_container' =>   @services['frontend']['name'],
        'webserver_service' =>    @services['webserver']['default'],
        'database_service' =>     @services['database']['name'],
        'database_vendor' =>      @services['database']['vendor'],
        'mysql_env_vars' =>       @services['database']['vendors']['mysql']['env_vars'],
        'postgresql_env_vars' =>  @services['database']['vendors']['postgresql']['env_vars'],
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