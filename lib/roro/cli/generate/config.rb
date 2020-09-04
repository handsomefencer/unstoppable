module Roro
  class CLI < Thor
    
    desc "generate::config", "Generate a config file at .roro_config.yml" 
    map "generate::config" => "generate_config"
    
    def generate_config
      # create_file ".roro_config.yml", @config.env.to_yaml 
    end
  end 
end