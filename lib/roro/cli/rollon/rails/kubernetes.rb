require 'roro/cli/rollon/stories'
require 'roro/cli/rollon/rails/database'

module Roro

  class CLI < Thor
        
    desc "rollon::rails::kubernetes", "Generates files for and makes changes to your app 
      so it can run using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as 
      you go."
    map "rollon::rails::kubernetes" => "rollon_rails_kubernetes"
    
    def rollon_rails_kubernetes(options={}) 
      options.merge!({ story: { rails: [
        { database: { postgresql: {} }},
        { kubernetes: { postgresql: {} }},
        { ci_cd:    { circleci:   {} }}
      ] } } ) 
      configure_for_rollon(options)
      @config.structure[:actions].each {|a| eval a }
      startup_commands
    end
  end
end