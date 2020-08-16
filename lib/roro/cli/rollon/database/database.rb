module Roro

  class CLI < Thor

    no_commands do

      def configure_database 
        database = @config.thor_actions['configure_database']
        vendor = @config.master['services']['database']['vendors']
        case database
        when 'p'
          @config.app['database_vendor'] = 'postgresql'
          @config.app['postgresql_env_vars'] = vendor['postgresql']['env_vars']
          configure_for_pg
        when 'm'
          @config.app['database_vendor'] = 'mysql'
          @config.app['mysql_env_vars'] = vendor['mysql']['env_vars']
          configure_for_mysql
        end
        
        %w(development production test staging ci).each do |environment| 
          template(
            'base/.env/web.env.tt',
            "roro/containers/app/#{environment}.env", @config.app
          )
        end
      end
    end 
  end 
end
      
