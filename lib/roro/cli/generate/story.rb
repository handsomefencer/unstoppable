module Roro
  class CLI < Thor
    
    desc "generate::story", "Generate a config file at .roro_config.yml to use later" 
    map "generate::story" => "generate_story"
    
    def generate_story
      
      @config ||= Roro::Configuration.new(options)
      # configuration = {
      #   env_vars: @config.env.keys,
      #   intentions: @config.intentions,
      #   story: @config.structure['story']
      # }
      # create_file ".roro_configurator.yml", @config.env.to_yaml 
    end
  end 
end