require 'roro/cli/rollon/stories'
require 'roro/cli/rollon/rails/database'

module Roro

  class CLI < Thor
        
    desc "rollon::rails", "Generates files for and makes changes to your app 
      so it can run using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as 
      you go."
    map "rollon::rails" => "rollon_rails"
    
    def rollon_rails(options={}) 
      rollon
    end
  end
end