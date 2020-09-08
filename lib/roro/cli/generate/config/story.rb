module Roro
  class CLI < Thor
    include Thor::Actions
    
    desc "generate::config::story", "Generates a config file " 
    map "generate::config::story" => "generate_config_story"

    def generate_config_story
      # master_config = YAML.load_file(ENV['PWD'] + "/lib/roro/cli/roro_configurator.yml")
      # template 'base/.roro_config.yml', '.roro_config.yml'
    end

    no_commands do
      
      def store_roro_configuration 
      
      end
    end
  end 
end