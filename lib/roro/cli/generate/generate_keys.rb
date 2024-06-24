# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:keys', 'Generates a key for each <environment>.smart.env file.'

    map 'generate:keys'  => 'generate_keys'
    map 'generate:key'   => 'generate_keys'

    def generate_keys(*environments)
      # raise Roro::Error if environments.empty?
      key_writer = Roro::Crypto::KeyWriter.new
      key_writer.write_keyfiles(environments.uniq)
    end
  end
end
