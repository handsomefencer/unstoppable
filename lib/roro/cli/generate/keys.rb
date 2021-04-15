module Roro

  class CLI < Thor

    desc "generate::key", "Generate a key inside roro/keys. Takes the name of
      an environment as an argument to private .env files from
    encrypted .env.enc files inside the roro directory.
    Expose encrypted files"

    map "generate::key" => "generate_key"
    method_option :environment, type: :hash, default: {}, desc: "Pass a list of environment variables like so: env:var", banner: "development, staging"

    def generate_key(*args)
      generate_key_or_keys(*args)
    end

    desc "generate::keys", "Generate keys for each environment inside roro/keys.
      If you have .env files like 'roro/containers/app/[staging_env].env' and
      'roro/[circle_ci_env].env' it will generate '/roro/keys/[staging_env].key'
      and '/roro/keys/[circle_ci_env].key'."
    map "generate::keys" => "generate_keys"

    def generate_keys(*args)
      generate_key(*args)
    end

    no_commands do

      def gather_environments
        environments = []
        ['.env', '.env.enc'].each do |extension|
          HandsomeFencer::Crypto.source_files('roro', extension).each do |env_file|
            environments << env_file.split('/').last.split(extension).last
          end
        end
        environments.uniq
      end

      def generate_key_or_keys(*args)
        environments = args.first ? [args.first] : gather_environments
        environments.each do |environment|

          confirm_files_decrypted?(environment)
          create_file "roro/keys/#{environment}.key", encoded_key
        end
      end

      def encoded_key
        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @salt = '8 octets'
        @new_key = @cipher.random_key
        Base64.encode64(@new_key)
      end

      def confirm_files_decrypted?(environment)
        orphan_encrypted = []
        Roro::Crypto.source_files('.', '.env.enc').each do |file|
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
