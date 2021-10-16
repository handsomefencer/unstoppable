module Roro
  module Crypto
    class Obfuscator

      def initialize
        @writer = FileWriter.new
        @cipher = Cipher.new
        @mise   = Roro::CLI.mise
      end

      def obfuscate_file(file, key)
        encrypted_content = @cipher.encrypt(File.read(file), key)
        @writer.write_to_file(file + '.enc', encrypted_content)
      end

      def obfuscate(environments = [], directory = @mise, extension = '.env')
        environments = gather_environments(directory, extension) if environments.empty?
        environments.each do |environment|
          obfuscatable = source_files(directory, "#{environment}*#{extension}")
          obfuscatable.each { |file| obfuscate_file(file, get_key(environment))}
        end
      end
    end
  end
end
