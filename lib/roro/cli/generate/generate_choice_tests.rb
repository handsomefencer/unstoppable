# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:choice_tests', 'Generate tests from stacks.'
    map 'generate:choice_tests' => 'generate_choice_tests'

    method_options choice: :string

    def generate_choice_tests(choice = nil)
      choice
      byebug
      # @env = { adventure_name: adventure.split('/').last }
      # location = "lib/roro/stacks/#{adventure}"
      # directory 'adventure', location, @env
      # generate_annotations
      # generate_annotations("#{location}/test/0/_test.rb")
    end

    no_commands do
    end
  end
end
