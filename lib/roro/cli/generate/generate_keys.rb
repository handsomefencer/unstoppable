require 'openssl'
require 'base64'
require 'handsome_fencer/crypto'

module Roro

  class CLI < Thor

    include Thor::Actions
    include HandsomeFencer::Crypto

    desc "generate_keys", "Generates keys for all environments. If you have .env files like './**/production.env' and './**/staging.env' this command assumes you need keys for the production and staging environments, and will generate them for you."

    def generate_keys
      generate_key
    end

    desc "generate_key", "Generate a key for each environment"
    method_option :environment, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "development, staging"

    def generate_key(*args)
      environments = args.first ? [args.first] : gather_environments
      environments.each do |environment|
        
        confirm_files_decrypted?(environment)
        create_file "roro/keys/#{environment}.key", encoded_key
      end
    end

    no_commands do

      def encoded_key
        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @salt = '8 octets'
        @new_key = @cipher.random_key
        Base64.encode64(@new_key)
      end

      def gather_environments
        environments = []
        ['.env', '.env.enc'].each do |extension|
          HandsomeFencer::Crypto.source_files('roro', extension).each do |env_file|
            environments << env_file.split('/').last.split(extension).last
          end
        end
        environments.uniq
      end

      def confirm_files_decrypted?(environment)
        orphan_encrypted = []
        HandsomeFencer::Crypto.source_files('.', '.env.enc').each do |file|
          unless File.exist? file.split('.enc').first
            orphan_encrypted << file 
          end
        end
        if !orphan_encrypted.empty?
          raise Roro::Error.new("You have an encrypted files (.env.enc) #{orphan_encrypted} that do not have corresponding decrypted files (.env). Please decrypt or remove these encrypted files before generating a new key for #{environment}.")
        end
        true
      end
    end
  end
end
