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

    def source_files(directory, pattern)
      source_files = Dir.glob(directory + "/**/*#{pattern}")
      error_message = "#{pattern} files in #{directory}"
      case   
      when source_files.empty? && pattern.eql?('.env')
        raise EncryptableError, "No encryptable #{error_message}" 
      when source_files.empty? && pattern.eql?('.env.enc')
        raise DecryptableError, "No decryptable #{error_message}"
      else 
        source_files
      end   
    end

    def gather_environments(directory, extension)
      environments = []
      source_files(directory, extension).each do |source_file|
        environments << source_file.split('/').last.split('.').first
      end
      if environments.empty? 
        raise EnvironmentError, "No files in the #{directory} directory matching #{extensions.join(' or ')}"
      else 
        environments.uniq
      end
    end

    def generate_keys(environments, directory, extension)
      environments ||= gather_environments(directory, extension)
      environments.each do |environment|
        write_to_file generate_key, "#{directory}/keys/#{environment}.key"
      end
    end
    
    def obfuscate(environments, directory, pattern)
      environments ||= gather_environments(directory, pattern)
      environments.each do |environment| 
        obfuscatable = source_files(directory, pattern)
        case 
        when obfuscatable.empty? 
          byebug 
        else   
          source_files(directory, pattern).each do |file|
            encrypt(file, environment)
          end
        end
      end 
    end

    def write_to_file(data, filename)
      if File.exist?(filename)
        raise DataDestructionError, "Existing file at #{filename}. Please remove it and try again."
      else
        File.open(filename, "w") { |io| io.write data }
      end
    end

    def build_cipher(environment)
      @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
      @salt = '8 octets'
      @pass_phrase = get_key(environment)
      @cipher.encrypt.pkcs5_keyivgen @pass_phrase, @salt
    end

    def encrypt(file, environment)
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

    def expose(env=nil, dir=nil, ext=nil)
      ext = ext || "#{env}.env.enc"
      source_files(dir, ext).each do |file|
        decrypt(file, env)
      end
    end

    def get_key(environment, directory='roro')
      env_key = environment.upcase + '_KEY'
      key_file = Dir.glob("roro/keys/#{environment}.key").first
      case
      when ENV[env_key].nil? && key_file.nil?
        raise KeyError, "No #{env_key} set. Please set one as a variable or in a file."
      when ENV[env_key]
        ENV[env_key]
      when File.exist?(key_file)
        File.read(key_file).strip
      end
    end
  end
end