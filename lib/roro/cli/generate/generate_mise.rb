# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate MISE', 'Generate mise en place.'
    map 'generate:mise'  => 'generate_mise'
    method_options :containers => :array


    def generate_mise(mise_name = mise)
      create_file "#{mise_name}/#{mise_name}.roro"
      generate_containers(options[:containers])
    end
  end
end
