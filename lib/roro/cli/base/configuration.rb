
module Roro

  class CLI < Thor
    
    no_commands do
      
      def get_configuration_variables(hash={})
        options["interactive"] ? set_interactively : set_from_defaults
        hash.each { |k,v| @env_hash[k] = v } unless hash.nil? 
        @env_hash[:deploy_tag] = "${CIRCLE_SHA1:0:7}"
        @env_hash[:server_port] = "22"
        @env_hash[:server_user] = "root"
        @env_hash
      end
      
      def set_from_defaults
        @env_hash = configuration_hash
        @env_hash.map do  |key, hash| 
          @env_hash[key] = hash.values.last 
        end
        @env_hash
      end
      
      def set_interactively
        @env_hash = configuration_hash
        @env_hash.map do |key, prompt|
          answer = ask("Please provide #{prompt.keys.first} or hit enter to accept: \[ #{prompt.values.first} \]")
          @env_hash[key] = (answer == "") ? prompt.values.first : answer
        end  
      end
      
      def confirm_dependencies
        dependencies = [
          {
            system_query: "which docker",
            warning: "Docker isn't installed",
            suggestion: "https://docs.docker.com/install/"
          }, {
            system_query: "which docker-compose",
            warning: "Docker Compose isn't installed",
            suggestion: "https://docs.docker.com/compose/install/"

          }, {
            system_query: "docker info",
            warning: "the Docker daemon isn't running",
            suggestion: "https://docs.docker.com/config/daemon/#start-the-daemon-manually"
          }
        ]

        dependencies.each do |dependency|
          confirm_dependency(dependency)
        end
      end
      
      
      
      def confirm_dependency(options)
        msg = []
        msg << ""
        msg << delineator
        msg << "It looks like #{options[:warning]}. The following bash command returns false:"
        msg << "\t$ #{options[:system_query]}"
        msg << "Please try these instructions:"
        msg << ("\t" + options[:suggestion])
        msg << delineator
        conditional = options[:conditional] ? eval(options[:conditional]) : system(options[:system_query])
        if conditional == false
          raise(Roro::Error.new(msg.join("\n\n")))
        end
      end

      
      private
      
      def configuration_hash
        {
          app_name: {
            "the name of your app" => `pwd`.split('/').last.strip! 
          },
          ruby_version: {
            "the version of ruby you'd like" => `ruby -v`.scan(/\d.\d/).first 
          },
          server_host: {
            "the ip address of your server" => "ip-address-of-your-server"
          },
          database_container: {
            "the name of your database container" => "database"
          },
          frontend_container: {
            "the name of your frontend container" => "frontend"
          },
          server_container: {
            "the name of your server container" => "nginx"
          },
          dockerhub_email: {
            "your Docker Hub email" => "your-docker-hub-email"
          },
          dockerhub_user: {
            "your Docker Hub username" => "your-docker-hub-user-name" 
          },
          dockerhub_org: {
            "your Docker Hub organization name" => "your-docker-hub-org-name"
          },
          dockerhub_password: {
            "your Docker Hub password" => "your-docker-hub-password"
          },
          postgres_user: {
            "your Postgres username" => "postgres"
          },
          postgres_password: {
            "your Postgres password" => "your-postgres-password"
          } 
        }
      end
    end
  end 
end
