require 'handsome_fencer/crypto'

module Roro

  class CLI < Thor
    
    no_commands do 
      include Thor::Actions
      include HandsomeFencer::Crypto
  
      def obfuscate(*args)
        environments = args.first ? [args.first] : gather_environments
        environments.each do |environment|
          HandsomeFencer::Crypto.obfuscate(environment, 'roro')
        end
      end
    end
  end
end
