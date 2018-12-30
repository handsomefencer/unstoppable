module Roro

  class CLI < Thor

    include Thor::Actions

    desc "greenfield", "Greenfield a brand new rails app using Docker's instructions"

    method_option :env_vars, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "key1:value1 key2:value2"
    method_option :interactive, desc: "Set up your environment variables as you go."

    def greenfield(app=nil)
      self.destination_root = self.destination_root + "/#{app}" unless app.nil?
      if app.nil? && !Dir.empty?('.')
        raise Roro::Error.new("Oops -- Roro can't greenfield a new Rails app for you unless the current directory is empty.")
      end
      copy_file 'greenfield/Gemfile', 'Gemfile'
      copy_file 'greenfield/Gemfile.lock', 'Gemfile.lock'
      copy_file 'greenfield/docker-compose.yml', 'docker-compose.yml'
      copy_file 'greenfield/Dockerfile', 'Dockerfile'
      copy_file 'greenfield/greenfield-entrypoint.sh', 'greenfield-entrypoint.sh'
      copy_file 'greenfield/config/database.yml.example', 'config/database.yml.example'
      system 'sudo chown -R $USER:$USER .'
      system 'docker-compose run web rails new . --force --database=postgresql'
      system 'sudo chown -R $USER:$USER .'
      system 'docker-compose build'
      system 'sudo chown -R $USER:$USER .'
      system 'mv -f config/datbase.yml.example config/database.yml'
      system 'docker-compose up -d'
      system 'docker-compose run web rake db:create'
    end


  end
end
