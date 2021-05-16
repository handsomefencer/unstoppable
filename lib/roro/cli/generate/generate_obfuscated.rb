# require 'roro/crypto'

module Roro

  class CLI < Thor

    desc "generate::obfuscated", "Encrypts .env files for safe storage."
    map "generate::obfuscated" => "generate_obfuscated"
    map "generate:obfuscated"  => "generate_obfuscated"
    
    def generate_obfuscated(*environments)
      obfuscator = Roro::Crypto::Obfuscator.new 
      obfuscator.obfuscate(environments, './roro', '.env')
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
