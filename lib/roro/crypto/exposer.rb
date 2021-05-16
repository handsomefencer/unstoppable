module Roro::Crypto
  class Exposer

    include FileReflection

    def initialize 
      @writer = FileWriter.new 
      @cipher = Cipher.new 
    end

    def expose_file(file, key) 
      encrypted_content = File.read(file)
      decrypted_content = @cipher.decrypt(encrypted_content, key)
      @writer.write_to_file(file.split('.enc').first, decrypted_content)
    end 

    def expose(environments, directory, ext)
      if environments.empty?
        environments = gather_environments(directory, ext)
      else 
        environments.each { |environment| get_key(environment) }
      end 
      environments.each do |environment|
        exposable = source_files(directory, "#{environment}*#{ext}")
        exposable.each { |file| expose_file(file, get_key(environment))}
      end 
    end
  end
end