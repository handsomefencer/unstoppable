# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:adventure_tests', 'Generate tests from stacks.'
    map 'generate:adventure_tests' => 'generate_adventure_tests'

    method_options adventure: :string

    def generate_adventure_tests(kase = nil)
      reflector = Roro::Configurators::Reflector.new
      itineraries = reflector.itineraries

      kases = kase ? [kase] : reflector.cases
      kases.each_with_index do |choice, index|
        @env = { adventure_title: itineraries[index].join(' & ') }
        location = "test/roro/stacks/#{choice.join('/')}"
        directory 'adventure_test', location, @env
      end
    end
  end
end
