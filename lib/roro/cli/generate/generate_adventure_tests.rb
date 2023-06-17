# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:adventure_tests', 'Generate tests from stacks.'
    map 'generate:adventure_tests' => 'generate_adventure_tests'

    method_options adventure: :string

    def generate_adventure_tests(_kase = nil)
      reflector = Roro::Configurators::StackReflector.new
      adventures = reflector.adventures

      adventures.each do |key, value|
        @env = { adventure_title: "#{key.gsub(' ', ' -> ')}: #{value.dig(:title)}" }
        path = value[:itinerary].map { |item| item.split(': ').join('/') }.join('/')
        location = "test/roro/stacks/#{key.gsub(' ', '/')}"
        directory 'adventure_test', location, @env
      end
    end
  end
end
