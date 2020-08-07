require 'byebug'
module Roro

  class CLI < Thor

    desc "rollon", "Generates files necessary to greenfield a new app within a dockerized rails container, along with a set of files necessary for continuous deployment using CircleCI"
    method_option :interactive, desc: "Set up your environment variables as you go."

    def rollon
      if Dir['./*'].empty?
        raise Roro::Error.new("Oops -- Roro can't roll itself onto a Rails app if it doesn't exist. Please either change into a directory with a Rails app or generate a new one using '$ roro greenfield'.")
      end
      get_configuration_variables

      case ask("Configure using the Quickstart, Curated, or HandsomeFencer way?\n\n(1) Quikstart\n\n(2) Curated\n\n(3) HandsomeFencer\n\n", { default: '2', limited_to: %w(1 2 3) })
      when '1'
        quickstart_way
      when '2'
        curated_way
      when '3'
        handsome_way
      end
    end

    no_commands do

      def quickstart_way
        copy_file "quickstart/docker-compose.yml", 'docker-compose.yml'
        copy_file "quickstart/entrypoint.sh", 'entrypoint.sh'
        copy_file "quickstart/database.yml", "config/database.yml"
        template "quickstart/Dockerfile", 'Dockerfile', @env_hash

        insert_pg_gem_into_gemfile
        system 'sudo chown -R $USER .'
      end

      def curated_way
        if ask('Configure $stdout.sync for docker?', choices).eql?('y')
          config_std_out_true
        end
        if ask('Configure .gitignore for roro?', choices).eql?('y')
          gitignore_sensitive_files
        end
        if ask('Add RoRo to your Gemfile?', choices).eql?('y')
          insert_roro_gem_into_gemfile
        end
        if ask("Backup 'config/database.yml'?").eql?('y')
          FileUtils.mv 'config/database.yml', "config/database.yml.backup"
        end
        copy_circleci
        copy_roro
        copy_docker_compose
        copy_config_database_yml
      end

      def handsome_way
        if Dir['./*'].empty?
          raise Roro::Error.new("Oops -- Roro can't roll itself onto a Rails app if it doesn't exist. Please either change into a directory with a Rails app or generate a new one using '$ roro greenfield'.")
        end
        if ask('Configure $stdout.sync for docker?', choices).eql?('y')
          config_std_out_true
        end
        if ask('Configure .gitignore for roro?', choices).eql?('y')
          gitignore_sensitive_files
        end
        if ask('Add RoRo to your Gemfile?', choices).eql?('y')
          insert_roro_gem_into_gemfile
        end
        if ask('Add handsome_fencer-test to your Gemfile?', choices).eql?('y')
          insert_hfci_gem_into_gemfile
        end
        if ask("Backup 'config/database.yml'?").eql?('y')
          FileUtils.mv 'config/database.yml', "config/database.yml.backup"
        end
        copy_base_files
      end
    end
  end
end