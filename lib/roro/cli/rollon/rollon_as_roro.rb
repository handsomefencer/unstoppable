module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_roro
        directory 'roro/', './', @env_hash
        %w(development production test staging ci).each do |environment| 
          @env_hash[:rails_env] = environment
          template(
            'base/.env/web.env.tt',
            "roro/containers/app/#{environment}.env", @env_hash)
          template(
            'base/.env/database.env.tt',
            "roro/containers/database/#{environment}.env", @env_hash)
        end
        template 'base/Dockerfile.tt', 'roro/containers/app/Dockerfile', @env_hash
        copy_file 'base/.dockerignore', '.dockerignore'

        
        # if ask('Configure $stdout.sync for docker?', choices).eql?('y')
        #   config_std_out_true
        # end
        # if ask('Configure .gitignore for roro?', choices).eql?('y')
        #   gitignore_sensitive_files
        # end
        # if ask('Add RoRo to your Gemfile?', choices).eql?('y')
        #   insert_roro_gem_into_gemfile
        # end
        # if ask('Add handsome_fencer-test to your Gemfile?', choices).eql?('y')
        #   insert_hfci_gem_into_gemfile
        # end
        # if ask("Backup 'config/database.yml'?").eql?('y')
        #   FileUtils.mv 'config/database.yml', "config/database.yml.backup"
        # end
        # copy_base_files
      end
    end
  end
end