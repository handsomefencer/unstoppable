require 'roro/crypto/file/reflection'
module Roro::Crypto
    
  class KeyManager < Thor
    # include Roro::Crypto::FileReflection
    include Roro::Crypto
    include Thor::Actions

    no_commands do 

      def generate_keyfile(environment) 
        cipher = Roro::Crypto::Cipher.new
        create_file "./roro/keys/#{environment}.key", cipher.generate_key 
      end

    end


    # def generate_keys(keys, dir, ext)
    #   (keys.empty? ? gather_environments(dir, ext) : keys).each do |key|
    #     write_to_file generate_key, "#{dir}/keys/#{key}.key"
    #   end
    # end

    # def expose(environments, dir, ext)
    #   if environments.empty? 
    #     environments = gather_environments('./roro/keys', '.key')
    #   end 
    #   environments.each do |environment| 
    #     pattern = "#{environment}*#{ext}" 

    #     exposable = source_files(dir, pattern)
    #     if exposable.empty?
    #       puts "No #{environment} files in ./roro matching #{pattern}"
    #     end
    #     source_files(dir, pattern).each do |file|
    #       decrypt(file, environment)
    #     end
    #   end
    # end

    # def obfuscate(envs, dir, ext)
    #   environments = envs.empty? ? gather_environments(dir, ext) : envs
    #   environments.each do |environment|
    #     pattern = "#{environment}*#{ext}" 
    #     get_key(environment)
    #     encryptable_files = source_files(dir, pattern)
    #     if encryptable_files.empty?
    #       puts "No #{environment} files in ./roro matching #{pattern}"
    #     end 
    #     encryptable_files.each do |file|
    #       encrypt(file, environment)
    #     end
    #   end 
    # end

    # def write_to_file(data, filename)
    #   if File.exist?(filename)
    #     raise DataDestructionError, "Existing file at #{filename}. Please remove it and try again."
    #   else
    #     File.open(filename, "w") { |io| io.write data }
    #   end
    # end

    
    # def encrypt(file, key)
    #   build_cipher(key)
    #   encrypted = @cipher.update(File.read file) + @cipher.final
    #   write_to_file(Base64.encode64(encrypted), file + '.enc')
    # end
    
    
    # def get_key(environment, dir='roro')
    #   env_key = environment.upcase + '_KEY'
    #   key_file = Dir.glob("roro/keys/#{environment}.key").first
    #   case
    #   when ENV[env_key].nil? && key_file.nil?
    #     raise KeyError, "No #{env_key} set. Please set one as a variable or in a file."
    #   when ENV[env_key]
    #     ENV[env_key]
    #   when File.exist?(key_file)
    #     File.read(key_file).strip
    #   end
    # end
  end
end