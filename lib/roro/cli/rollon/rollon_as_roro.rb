module Roro

  class CLI < Thor

    no_commands do

      def rollon_as_roro
        directory 'roro/roro', 'roro', @env_hash
        copy_file 'base/.env/development/web', 'roro/containers/app/development.env'
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