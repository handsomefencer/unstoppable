module Roro

  class CLI < Thor
    map "generate::key" => "generate_keys"
    method_option :environment, type: :hash, default: {}, desc: "Generates a key for each argument.", banner: "development, staging"

    desc "generate::keys", "Generates a key for each <environment>.env file."
    map "generate::keys" => "generate_keys"

    def generate_keys(*environments)
      Roro::Crypto.generate_keys(environments, './roro', '.env')
    end
  end
end
