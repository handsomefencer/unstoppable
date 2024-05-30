# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:adventure_tests', 'Generate tests from stacks.'
    map 'generate:adventure_tests' => 'generate_adventure_tests'

    method_options adventure: :string

    def generate_adventure_tests(_kase = nil)
      reflector = Roro::Configurators::StackReflector.new
      # debugger
      reflector.adventures.values.each { |a| generate_test_stack(a) }
        #       manifest_names = hash.dig(:inflection_names)
        # manifest_names.each do |name|
        #   src = 'stack/tests/tests/_manifest.yml'
        #   copy_file(src, "#{dest}/_manifest_#{name}.yml", @env)
        #   # debugger if manifest_names.first.eql?(name)
        #   template(src, "#{dest}/_manifest.yml", @env) if manifest_names.first.eql?(name)
        # end

    end

    no_commands do
      def describe_block(hash)
        {}.tap do |h|
          h[:adventure_title] = [].tap do |a|
            hash.dig(:choices).each_with_index do |c, i|
              a << "#{hash.dig(:picks)[i]} #{c}"
            end
          end.join(' -> ')
        end
      end

      def generate_test_stack(hash)
        @env = describe_block(hash)
        dest = 'test/roro/stacks'
        hash[:choices].each do |c|
          if c.eql?(hash[:choices][-1])
            src = 'stack/tests/tests'
            directory(src, "#{dest}/#{c.downcase}", @env)
          end
          dest = "#{dest}/#{c.downcase}"
        end
      end
    end
  end
end
