module Roro

  class CLI < Thor

    no_commands do
      
      def configure_for_pg 
        insert_db_gem('pg')
        copy_file 'base/config/database.pg.yml', 'config/database.yml', force: true
        config = @config.app.clone
        %w(development production test staging ci).each do |environment| 
          config['rails_env'] = environment
          
          source = 'base/.env/database.pg.env.tt'
          target = "roro/containers/database/#{environment}.env" 
          template( source, target, config )
        end
      end
    end
  end
end