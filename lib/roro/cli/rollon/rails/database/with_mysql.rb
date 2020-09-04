module Roro

  class CLI < Thor

    no_commands do
      
      def configure_for_mysql 
        insert_db_gem('mysql2')
        copy_file 'rails/config/database.mysql.yml', 'config/database.yml', force: true
        config = @config.env.clone

        %w(development production test staging ci).each do |environment| 
          config['rails_env'] = environment
          
          source = 'rails/dotenv/database.mysql.env.tt'
          target = "roro/containers/database/#{environment}.env" 
          template( source, target, config )
        end
      end
    end
  end
end