module Roro

  class CLI < Thor

    no_commands do

      def configure_database 
        database = @config.thor_actions['configure_database']
        case database
        when 'p'
          @config.app['database_vendor'] = 'postgresql'
          configure_for_pg
          
        when 'm'
          @config.app['database_vendor'] = 'mysql'
          configure_for_mysql
        end
        
        %w(development production test staging ci).each do |environment| 
          @config.app['rails_env'] = environment
          template(
            'base/.env/web.env.tt',
            "roro/containers/app/#{environment}.env", @config.app
          )
        end
      end
    end 
  end 
end
      
