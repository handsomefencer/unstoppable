module Roro

  class CLI < Thor

    no_commands do

      def configure_database 
        case 
        when @config.thor_actions['configure_database'].eql?('p')
          configure_for_pg
        end  
      end
    end 
  end 
end
      
