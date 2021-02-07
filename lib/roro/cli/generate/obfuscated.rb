require 'roro/crypto'

module Roro

  class CLI < Thor

    desc "generate::obfuscated", "obfuscates any files matching the pattern ./roro/**/*.env"
    map "generate::obfuscated" => "generate_obfuscated"

    def generate_obfuscated(*args)
      environments = args.first ? [args.first] : gather_environments
      environments.each do |environment|
        Roro::Crypto.obfuscate(environment, 'roro')
      end
    end
  end
end
