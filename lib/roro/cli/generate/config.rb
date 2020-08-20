module Roro
  class CLI < Thor
    include Thor::Actions
    
    # desc "generate::config::roro", "Generate a config file at .roro_config.yml" 
    # map "generate::config::roro" => "generate_roro_config"

     
    # def generate_roro_config
    #   create_file ".roro_config.yml", @config.app.to_yaml 
    # end
  end 
end