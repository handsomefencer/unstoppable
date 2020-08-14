module Roro
  class CLI < Thor
    include Thor::Actions
    
    desc "generate::config::rails", "Generates a config file to use roro with
      a rails app at .roro.yml" 
    map "generate::config::rails" => "generate_config_rails"

    def generate_config_rails
      master_config = YAML.load_file("lib/roro/cli/roro_configurator.yml")
      byebug
      template 'base/.roro.yml', '.roro.yml'
    end
    
    # namespace :generate do 
    #   namespace :config do 
        
    #   end 
    # end

    no_commands do
    end
  end 
end