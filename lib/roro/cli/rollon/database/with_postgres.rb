module Roro

  class CLI < Thor

    no_commands do
      
      def configure_for_pg 
        insert_pg_gem_into_gemfile
        copy_file 'base/config/database.pg.yml', 'config/database.yml', force: true
        config = @config.app
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