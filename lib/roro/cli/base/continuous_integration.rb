
module Roro

  class CLI < Thor
    
    no_commands do
   
      def copy_circleci 
        directory 'base/circleci', '.circleci', @env_hash
      end  
    end
  end 
end
