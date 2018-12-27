module Roro

  class CLI < Thor

    include Thor::Actions

    # def self.source_root
    #   File.dirname(__FILE__) + '/templates/greenfield'
    # end

    desc "greenfield", "Generates files necessary to greenfield a new app within a dockerized rails container, along with a set of files necessary for continuous deployment using CircleCI"

    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."

    def greenfield(app=nil)
      self.destination_root = self.destination_root + "/#{app}" unless app.nil?
      if app.nil? && !Dir.empty?('.')
        raise Roro::Error.new("Oops -- Roro can't greenfield a new Rails app for you unless the current directory is empty.")
      end
      # directory '.', '.'
      # copy_file '/greenfield/Gemfile', 'Gemfile'
      # copy_file '/greenfield/Gemfile.lock', 'Gemfile.lock'
      copy_file 'greenfield/docker-compose.yml', 'docker-compose.yml'
      # copy_file '/greenfield/Dockerfile', 'Dockerfile'
    end
  end
end
