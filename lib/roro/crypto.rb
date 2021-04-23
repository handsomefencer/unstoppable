require "openssl"
require "base64"
module Roro::Crypto

  class << self

    def generate_key
      @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
      @salt = '8 octets'
      @new_key = @cipher.random_key
      Base64.encode64(@new_key)
    end

    def write_to_file(data, filename)
      File.open(filename, "w") { |io| io.write data }
    end

    def generate_key_file(directory, environment)
      write_to_file(generate_key, directory + "/" + environment + ".key")
    end

    def source_files(directory=nil, extension=nil)

      Dir.glob(directory + "/**/*#{extension}")
    end

    def build_cipher(environment)
      @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
      @salt = '8 octets'
      @pass_phrase = get_key(environment)
      @cipher.encrypt.pkcs5_keyivgen @pass_phrase, @salt
    end

    def encrypt(file, environment=nil)
      environment ||= file.split('.')[-2].split('/').last
      build_cipher(environment)
      encrypted = @cipher.update(File.read file) + @cipher.final
      write_to_file(Base64.encode64(encrypted), file + '.enc')
    end

    def decrypt(file, environment=nil)
      environment ||= file.split('.')[-3].split('/').last
      build_cipher(environment)
      encrypted = Base64.decode64 File.read(file)
      @cipher.decrypt.pkcs5_keyivgen @pass_phrase, @salt
      decrypted = @cipher.update(encrypted) + @cipher.final
      decrypted_file = file.split('.enc').first
      write_to_file decrypted, decrypted_file
    end

    def obfuscate(env=nil, dir=nil, ext=nil)
      ext = ext || "#{env}*.env"
      source_files(dir, ext).each { |file| encrypt(file, env) }
    end

    def expose(env=nil, dir=nil, ext=nil)
      ext = ext || "#{env}.env.enc"
      source_files(dir, ext).each do |file|

        decrypt(file, env)
      end
    end

    def get_key(environment, directory=nil)
      env_key = environment.upcase + '_KEY'
      key_file = source_files('./.', "#{directory}/#{environment}.key").first
      case
      when ENV[env_key].nil? && key_file.nil?
        raise DeployKeyError, "No #{env_key} set."
      when ENV[env_key]
        ENV[env_key]
      when File.exist?(key_file)
        File.read(key_file).strip
      end
    end
  end
end