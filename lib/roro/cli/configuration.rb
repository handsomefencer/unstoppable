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
        app_name: Dir.pwd.split('/').last,
        deployment_image_tag: @master['ci_cd']['circleci']['env_vars']['DEPLOY_TAG'], 
        dockerhub_email:      @registry['env_vars']['DOCKERHUB_EMAIL'],
        dockerhub_org:        @registry['env_vars']['DOCKERHUB_ORG'],
        dockerhub_user:       @registry['env_vars']['DOCKERHUB_USER'],
        dockerhub_password:   @registry['env_vars']['DOCKERHUB_PASSWORD'],
    
        ruby_version:         @services['server_app']['vendors']['rails']['version'],
        database_service:     @services['database']['name'],
        database_vendor:      @services['database']['vendor'],
        frontend_container:   @services['frontend']['name'],
        mysql_env_vars:       @services['database']['vendors']['mysql']['env_vars'],
        postgresql_env_vars:  @services['database']['vendors']['postgresql']['env_vars'],
        webserver_service:    @services['webserver']['default'],
      }
    end 
    
    def set_from_defaults 
      set_app_variables_from_defaults
      set_thor_actions_from_defaults
    end
    
    def set_thor_actions_from_defaults
      @choices.each { |key, value| @thor_actions[key] = value["default"] } 
    end
    
    def set_from_interactive
      @env_hash = configuration_hash
        @env_hash.map do |key, prompt|
          answer = ask  ("Please provide #{prompt.keys.first} or hit enter to accept: \[ #{prompt.values.first} \]")
          @env_hash[key] = (answer == "") ? prompt.values.first : answer
        end 
      
    end
    
    def set_from_config 
    end
  end
end