require 'thor'
require 'roro/cli/base/base'
require 'roro/cli/rollon/stories'
require 'roro/cli/rollon'
require 'roro/cli/greenfield'
require 'roro/cli/obfuscate'
require 'roro/cli/expose'
require 'roro/cli/ruby_gem'
require 'roro/cli/generate/config/rails'
require 'roro/cli/generate/config'
require 'roro/cli/generate/generate_keys'
require 'roro/cli/configuration'

module Roro
  
  class CLI < Thor
    
    include Thor::Actions
    
    def self.source_root
      File.dirname(__FILE__) + '/cli/templates'
    end
    
    desc "rollon::ruby_gem", "Generate files for containerized gem testing, CircleCI, and releasing to RubyGems."
    method_option :rubies, type: :array, banner: "2.5.3 2.4.2"
    map "rollon::ruby_gem" => "rollon_ruby_gem"

    def rollon_ruby_gem(*args) 
      ruby_gem(*args)
    end
    
    desc "rollon::rails", "Generates files for and makes changes to your app 
      so it can run using Docker containers."
    method_option :interactive, desc: "Set up your environment variables as 
      you go."
    map "rollon::rails" => "rollon_rails"
    
    def rollon_rails 
      rollon
    end

    
    desc "greenfield::rails", "Greenfield a new, dockerized rails app with
      either MySQL or PostgreSQL in a separate container."
    
    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."
    method_option :force, desc: "force over-write of existing files"

    map "greenfield::rails" => "greenfield_rails"
    
    def greenfield_rails(*args) 
      greenfield(*args)
    end
    desc "generate::exposed", "Generate private .env files from 
      encrypted .env.enc files inside the roro directory."
    map "generate::exposed" => "generate_exposed"
    
    def generate_exposed(*args) 
      expose(*args)
    end
    
    desc "generate::key", "Generate a key inside roro/keys. Takes the name of 
      an environment as an argument to private .env files from 
    encrypted .env.enc files inside the roro directory.
    Expose encrypted files"
    
    map "generate::key" => "generate_key"
    method_option :environment, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "development, staging"
    
    def generate_key(*args)
      generate_key_or_keys(*args)
    end

    desc "generate::keys", "Generate keys for each environment inside roro/keys.
      If you have .env files like 'roro/containers/app/[staging_env].env' and 
      'roro/[circle_ci_env].env' it will generate '/roro/keys/[staging_env].key'
      and '/roro/keys/[circle_ci_env].key'."
    map "generate::keys" => "generate_keys"

    def generate_keys(*args)
      generate_key(*args)
    end
    
    desc "generate::config", "Generate a config file at .roro_config.yml" 
    map "generate::config" => "generate_config"
    
    def generate_config
      create_file ".roro_config.yml", @config.app.to_yaml 
    end
    
    desc "generate::obfuscated", "obfuscates any files matching the pattern ./roro/**/*.env"
    map "generate::obfuscated" => "generate_obfuscated"
    
    def generate_obfuscated(*args) 
      obfuscate(*args)
    end
  end
end
