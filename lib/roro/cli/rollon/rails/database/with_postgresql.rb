module Roro

  class CLI < Thor

    no_commands do
      
      def configure_for_pg 
        copy_file 'rails/config/database.pg.yml', 'config/database.yml', force: true
        config = @config.env.clone
        %w(development production test staging ci).each do |environment| 
          config[:rails_env] = environment
          
          source = 'rails/dotenv/database.pg.smart.env.tt'
          target = "roro/containers/database/#{environment}.smart.env"
          template( source, target, config )
        end
      end
    end
  end
end