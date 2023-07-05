# frozen_string_literal: true

require 'byebug'
module Roro
  class CLI < Thor
    desc 'generate:adventure', 'Generate adventure for adventure tests.'
    map 'generate:adventure' => 'generate_adventure'

    method_options adventure: :string

    def generate_adventure(location)
      @env = { adventure_name: location.split('/').last }
      directory 'stack/stack', location, @env
    end

    no_commands do
      def adventure_name
        @env[:adventure_name]
      end
    end
  end
end
