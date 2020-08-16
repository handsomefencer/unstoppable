# module Roro
#   class CLI < Thor
#     include Thor::Actions
    
#     desc "generate::config::rails", "Generates a config file to use roro with
#       a rails app at .roro.yml" 
#     map "generate::config::rails" => "generate_config_rails"

#     def generate_config_rails
#       master_config = YAML.load_file(ENV['PWD'] + "/lib/roro/cli/roro_configurator.yml")
#       template 'base/.roro_config.yml', '.roro_config.yml'
#     end

#     no_commands do
#     end
#   end 
# end