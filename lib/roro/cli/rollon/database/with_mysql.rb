module Roro

  class CLI < Thor

    no_commands do
      
      def configure_for_mysql 
        insert_mysql_gem_into_gemfile
        copy_file 'base/config/database.mysql.yml', 'config/database.yml', force: true
        config = @config.app.clone

        %w(development production test staging ci).each do |environment| 
          config['rails_env'] = environment
          
          source = 'base/.env/database.mysql.env.tt'
          target = "roro/containers/database/#{environment}.env" 
          template( source, target, config )
        end
      end
    end
  end
end