module Roro
  class CLI < Thor

    desc "expose", "Expose encrypted files"

    def expose(*args)
      environments = args.first ? [args.first] : gather_environments
      environments.each do |environment|
        HandsomeFencer::Crypto.expose(environment, 'docker')
      end
    end
  end
end
