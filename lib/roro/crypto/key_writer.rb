# frozen_string_literal: true

module Roro
  module Crypto

    # Key writer Writes keys arguments for environments, directory and extension where
    # environments are the names of the keys to be generated, directory
    # is the destination folders the keys will be wrtten in and extension is
    # the extension of the key file.

    class KeyWriter
      include Roro::FileReflection

      def initialize
        @writer = FileWriter.new
        @cipher = Cipher.new
      end

      def write_keyfile(environment)
        destination = "./#{Roro::CLI.mise}/keys/#{environment}.key"
        @writer.write_to_file(destination, @cipher.generate_key)
      end

      def write_keyfiles(environments, directory, ext)
        environments = gather_environments(Dir.glob("#{Dir.pwd}/#{Roro::CLI.mise}/**/*"), ext) if environments.empty?
        environments.uniq.each { |environment| write_keyfile(environment) }
      end
    end
  end
end
