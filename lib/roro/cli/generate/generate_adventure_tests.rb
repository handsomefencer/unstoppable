# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:adventure_tests', 'Generate tests from stacks.'
    map 'generate:adventure_tests' => 'generate_adventure_tests'

    method_options adventure: :string

    def generate_adventure_tests(choice = nil)
      reflector = Roro::Configurators::Reflector.new
      kases = reflector.cases
      itineraries = reflector.itineraries

      choices = choice ? [choice] : kases
      choices.each_with_index do |choice, _index|
        @env = { adventure_title: itineraries[0].join(' & ') }
        location = "test/roro/stacks/#{choice.join('/')}"
        directory 'adventure_test', location, @env
      end
    end

    no_commands do
      # def
    end
  end
end
