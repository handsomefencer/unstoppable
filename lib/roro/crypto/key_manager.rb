require 'roro/crypto/file/reflection'
module Roro::Crypto
    
  class KeyManager
    include File::Reflection

    def initialize 
      @writer = File::Writer.new 
      @cipher = Cipher.new 
    end
    
    def write_keyfile(environment) 
      destination = "./roro/keys/#{environment}.key"
      @writer.write_to_file(destination, @cipher.generate_key)
    end
    
    def write_keyfiles(environments, directory, ext)
      environments = gather_environments(directory, ext) if environments.empty?
      environments.each { |environment| write_keyfile(environment) }
    end

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