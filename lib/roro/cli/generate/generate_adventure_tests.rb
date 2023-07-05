# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:adventure_tests', 'Generate tests from stacks.'
    map 'generate:adventure_tests' => 'generate_adventure_tests'

    method_options adventure: :string

    def generate_adventure_tests(_kase = nil)
      reflector = Roro::Configurators::StackReflector.new
      reflector.adventures.each do |_key, adventure|
        generate_test_stack(adventure)
      end
    end

    no_commands do
      def generate_test_stack(hash)
        @env = { adventure_title: 'describe block' }
        @env[:force] = true
        dest = 'test/roro/stacks'
        choices = hash[:choices]
        choices.each do |choice|
          @env[:choice] = choice
          @env[:shared_method] = dest.split('/').last
          if choice.eql?(choices.first)
            copy_shared_tests(dest)
          else
            template('stack/shared_tests/shared.rb.tt', "#{dest}/shared_tests.rb", @env)
          end
          directory('stack/stack_test', "#{dest}/#{choice}", @env) if choice.eql?(choices.last)
          dest = "#{dest}/#{choice}"
        end
      end

      def copy_shared_tests(dest)
        # byebug if dest.eql?('test/roro/stacks')
        template('stack/shared_tests/base.rb.tt', "#{dest}/shared_tests.rb", @env)
      end
    end
  end
end
