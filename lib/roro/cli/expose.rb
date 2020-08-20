module Roro
  class CLI < Thor
    
    no_commands do 

      def expose(*args)
        environments = args.first ? [args.first] : gather_environments
        environments.each do |environment|
          HandsomeFencer::Crypto.expose(environment, 'roro')
        end
      end
    end
  end
end