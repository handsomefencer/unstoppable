module Roro
  class CLI < Thor
    
    desc "generate::exposed", "Generate private .env files from encrypted .env.enc files inside the roro directory."
    map "generate::exposed" => "generate_exposed"
    
    def generate_exposed(*args) 
      environments = args.first ? [args.first] : gather_environments
      environments.each do |environment|
        Roro::Crypto.expose(environment, 'roro')
      end
    end
  end
end