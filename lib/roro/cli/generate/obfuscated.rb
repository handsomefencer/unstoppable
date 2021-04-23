require 'roro/crypto'

module Roro

  class CLI < Thor

    desc "generate::obfuscated", "obfuscates any files matching the pattern ./roro/**/*.env"
    map "generate::obfuscated" => "generate_obfuscated"

    def generate_obfuscated(*args)
      environments = args.first ? [args.first] : gather_environments
      check_for_obfuscatable(environments)
      check_for_keys(environments)
      environments.each do |environment|
        Roro::Crypto.obfuscate(environment, 'roro')
      end
    end


    no_commands do

      def check_for_obfuscatable(environments)
        if environments.empty?
          msg = "No .env files matching the
          pattern roro/**/*.env'. Please create one."
          raise Roro::Error.new(msg)
        end
      end

      def check_for_keys(environments)
        environments.each do |e|
          unless File.exist?("roro/keys/#{e}.key")
            msg = "No #{e} key file at roro/keys/{e}.key. Please generate one."
            raise Roro::Error.new(msg)
          end
        end
      end
    end
  end
end
