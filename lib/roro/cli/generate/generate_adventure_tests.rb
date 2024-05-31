# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:adventure_tests', 'Generate tests from stacks.'
    map 'generate:adventure_tests' => 'generate_adventure_tests'

    method_options adventure: :string

    def generate_adventure_tests(_kase = nil)
      reflector = Roro::Configurators::StackReflector.new
      @manifest_names =[]
      reflector.adventures.values.each { |a| generate_test_stack(a) }
      dest = 'test/roro/stacks'
      @manifest_names.uniq.each do |name|
          @env[:manifest_name] = name
          src = 'stack/tests/tests/_manifest.yml'
          if @manifest_names.first.eql?(name)
            @env[:manifest_name] = 'stacks'
            template(src, "#{dest}/_manifest.yml", @env)
          end
          template(src, "#{dest}/_manifest_#{name}.yml", @env)
      end
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
        @manifest_names += hash[:inflection_names]
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
