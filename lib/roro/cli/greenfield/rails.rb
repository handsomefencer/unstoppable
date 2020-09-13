module Roro

  class CLI < Thor
    
    desc "greenfield::rails", "Greenfield a new, dockerized rails app with
    either MySQL or PostgreSQL in a separate container."
  
    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."
    method_option :force, desc: "force over-write of existing files"

    map "greenfield::rails" => "greenfield_rails"
    
    def greenfield_rails
      greenfield
    end
  end
end
