# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:mise', 'Generate mise en place'
    map 'generate:mise'  => 'generate_mise'

    def generate_mise(mise_name = 'mise')
      create_file "#{mise_name}/#{mise_name}.roro"
      generate_containers
      generate_environments
      generate_obfuscated
      generate_exposed
    end
  end
end
