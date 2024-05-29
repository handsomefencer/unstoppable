# frozen_string_literal: true

module Roro
  module TestHelpers
    module ConfiguratorTestHelper

      def rollon_options
        {
          debuggerer: ENV['DEBUGGERER'].eql?('true'),
          rollon_dummies: @rollon_dummies || false,
          rollon_loud: @rollon_loud || false
        }
      end

      def assert_correct_manifest(dir)
        story = RollonTestHelper.new(dir, rollon_options)
        story.rollon
        story.choices.each do |fm|
          story.merge_manifests.dig(fm.to_sym)&.each do |filename, matchers|
            if matchers.nil?
              assert_file filename.to_s
            else
              matchers.each do |matcher|
                msg = "#{filename} in #{dir}/dummy/#{filename} does not contain #{matcher}"
                if matcher.is_a?(Hash)
                  assert_yaml(filename.to_s, matcher)
                elsif matcher.chars.first.match?('/')
                  regex = matcher.chars
                  regex.shift
                  regex.pop
                  regex.join
                  begin
                    assert_file(filename.to_s, eval("#{matcher}"))
                  rescue
                  end
                else
                  assert_file(filename.to_s, eval(matcher))
                end
              end
            end
          end
        end
      end

      def stub_journey(answers)
        Thor::Shell::Basic
          .any_instance
          .stubs(:ask)
          .returns(*answers)
      end

      def stubs_yes?(answer = 'yes')
        Thor::Shell::Basic.any_instance
                          .stubs(:yes?)
                          .returns(answer)
      end

      def stack_path(args = nil)
        append = defined?(stack) ? "/#{stack}" : nil
        prepend_valid = args.eql?(:invalid) ? 'invalid' : 'valid'
        stack_root ||= "#{Roro::CLI.test_root}/fixtures/dummies/stack/#{prepend_valid}"
        "#{stack_root}#{append}"
      end

      def assert_valid_stack
        assert_nil validator.validate(stack_path)
      end

      def quiet
        original_stderr = $stderr.clone
        original_stdout = $stdout.clone
        $stderr.reopen(File.new('/dev/null', 'w'))
        $stdout.reopen(File.new('/dev/null', 'w'))
        yield
      ensure
        $stdout.reopen(original_stdout)
        $stderr.reopen(original_stderr)
      end

      def expected_adventure_cases
        [
          '1 1 1',           '1 1 2',           '1 2 1 1 1',
          '1 2 1 1 2',       '1 2 1 2 1',       '1 2 1 2 2',
          '1 2 2 1',         '1 2 2 2',         '1 3 1 1 1 1 1 1',
          '1 3 1 1 1 1 1 2', '1 3 1 1 1 1 2 1', '1 3 1 1 1 1 2 2',
          '1 3 1 1 1 2 1 1', '1 3 1 1 1 2 1 2', '1 3 1 1 1 2 2 1',
          '1 3 1 1 1 2 2 2', '1 3 1 1 2 1 1 1', '1 3 1 1 2 1 1 2',
          '1 3 1 1 2 1 2 1', '1 3 1 1 2 1 2 2', '1 3 1 1 2 2 1 1',
          '1 3 1 1 2 2 1 2', '1 3 1 1 2 2 2 1', '1 3 1 1 2 2 2 2',
          '1 3 1 2 1 1 1',   '1 3 1 2 1 1 2',   '1 3 1 2 1 2 1',
          '1 3 1 2 1 2 2',   '1 3 1 2 2 1 1',   '1 3 1 2 2 1 2',
          '1 3 1 2 2 2 1',   '1 3 1 2 2 2 2',   '1 3 2 1',
          '1 3 2 2',         '2 1',             '2 2',
          '3 1',             '3 2'
        ]
      end
    end
  end
end
