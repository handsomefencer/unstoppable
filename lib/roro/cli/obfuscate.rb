require 'handsome_fencer/crypto'

module Roro

  class CLI < Thor

    include Thor::Actions
    include HandsomeFencer::Crypto

    desc "obfuscate", "obfuscates any files matching the pattern ./roro/**/*.env"

    def obfuscate(*args)
      environments = args.first ? [args.first] : gather_environments
      environments.each do |environment|
        HandsomeFencer::Crypto.obfuscate(environment, 'roro')
      end
    end
  end
end
