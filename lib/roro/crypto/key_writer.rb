module Roro::Crypto
  class KeyWriter

    include FileReflection

    def initialize 
      @writer = FileWriter.new 
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
  end
end