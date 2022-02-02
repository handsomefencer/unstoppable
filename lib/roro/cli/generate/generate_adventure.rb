# frozen_string_literal: true

module Roro

  class CLI < Thor

    desc 'generate:adventure', 'Generate adventure for adventure tests.'
    map 'generate:adventure' => 'generate_adventure'

    method_options :adventure => :string

    def generate_adventure(adventure)
      @getsome = { adventure_name: adventure.split('/').last }
      location =  "lib/roro/stacks/#{adventure}"
      directory 'adventure', location, @getsome
      generate_annotations("#{location}/test/0/_test.rb")
    end

    no_commands do
      def adventure_name
        @getsome[:adventure_name]
      end
    end
  end
end
