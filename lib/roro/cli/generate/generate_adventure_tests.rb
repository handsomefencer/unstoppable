# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:adventure_tests', 'Generate tests from stacks.'
    map 'generate:adventure_tests' => 'generate_adventure_tests'

    method_options adventure: :string

    def generate_adventure_tests(_kase = nil)
      reflector = Roro::Configurators::Reflector.new
      itineraries = reflector.itineraries

      # kases = kase ? [kase] : reflector.cases
      itineraries.each_with_index do |itinerary, _index|
        @env = { adventure_title: itinerary.join(' & ') }
        # byebug
        path = itinerary.map { |item| item.split(': ').join('/') }.join('/')
        # byebug
        location = "test/roro/stacks/#{path}"
        directory 'adventure_test', location, @env
      end
    end
  end
end
