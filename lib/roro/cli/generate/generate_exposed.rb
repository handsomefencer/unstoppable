module Roro
  class CLI < Thor
    
    desc "generate:exposed", "Decrypts .smart.env.enc files for all environments or those specified."
    map "generate:exposed"  => "generate_exposed"

    def generate_exposed(*environments)
      exposer = Roro::Crypto::Exposer.new
      exposer.expose(environments, './roro', '.env.enc')
    end
  end
end