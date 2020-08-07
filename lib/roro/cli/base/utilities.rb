
module Roro

  class CLI < Thor
    
    no_commands do  

      def choices 
        { default: 'y', limited_to: ["y", "n"] }
      end
      
      def own_if_required
        system 'sudo chown -R $USER .'
      end   
    end
  end 
end
