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
        @mise   = Roro::CLI.mise
      end

      def write_keyfile(environment, extension = '.key')
        destination = "#{@mise}/keys/#{environment}#{extension}"
        @writer.write_to_file(destination, @cipher.generate_key)
      end

      def write_keyfiles(environments = [], directory = nil, extension = nil)
        @writer.write_to_file("#{@mise}/keys/.keep", '')
        directory ||= @mise
        extension ||= '.key'
        if environments.empty?
          environments = gather_environments(directory, '.env').uniq
        end
        raise Roro::Error.new('missing envfironments') if environments.empty?

        environments.uniq.each { |environment| write_keyfile(environment, extension) }
      end
    end
  end
end
