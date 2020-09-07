module Roro

  class CLI < Thor

    no_commands do

      def configure_database 
        database = @config.intentions[:configure_database]
        case database
        when 'p'
          @config.env[:database_vendor] = 'postgresql'
          configure_for_pg
        when 'm'
          @config.env[:database_vendor] = 'mysql'
          configure_for_mysql
        end
        
        %w(development production test staging ci).each do |environment| 
          src = 'rails/dotenv/web.env.tt'
          dest = "roro/containers/app/#{environment}.env"
          template src, dest, @config.env
        end
      end
    end 
  end 
end
      
