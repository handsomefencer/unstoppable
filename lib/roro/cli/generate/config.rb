# module Roro
#   class CLI < Thor
    
#     desc "generate::config", "Generate a config file at .roro_config.yml" 
#     map "generate::config" => "generate_config"
    
#     def generate_config
#       @config ||= Roro::Configurator::Configuration.new(options)
#       configuration = {
#         env_vars: @config.env.keys,
#         intentions: @config.intentions,
#         story: @config.structure['story']
#       }
#       create_file ".roro_configurator.yml", @config.env.to_yaml 
#     end
#   end 
# end