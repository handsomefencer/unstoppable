# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:keys', 'Generates a key for each <environment>.smart.env file.'
    method_option :environment, type: :hash, default: {}, desc: 'Generates a key for each argument.',
                                banner: 'development, staging'

    map 'generate:keys'  => 'generate_keys'
    map 'generate:key'   => 'generate_keys'

    def generate_keys(*environments)
      key_writer = Roro::Crypto::KeyWriter.new
      mise = Roro::CLI.mise
      key_writer.write_keyfiles(environments, mise, '.env')
    end
  end
end
