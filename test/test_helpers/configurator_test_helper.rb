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

      def evaluate_contents_array(dir, file, matchers)
        matchers.each do |matcher|
          # msg = "#{file} in #{dir}/dummy/#{file} does not contain #{matcher}"
          if matcher.is_a?(Hash)
            assert_yaml(file, matcher)
          elsif matcher[-1].eql?('!')
            refute_content(file, matcher.strip[0..-2])
          elsif matcher[0].eql?('/')
            assert_content(file, eval("#{matcher}"))
          else
            assert_content(file, eval(matcher))
          end
        end
      end

      def evaluate_contents_hash(dir, file, expected, actual=nil, builder=nil)
        actual ||= read_yaml(file.to_s)
        expected.dup.each do |key, value|
          msg = [
            "debug -- dir: #{dir}",
            "file: #{file}",
            "key: #{key}",
            "value: #{value}"
          ]
          if key.to_s[-1] == '!'
            refute_includes actual.keys, key[0..-2].to_sym, msg
            expected.delete(key)
          end
          case value
          when nil
            debugger
          when Hash
            if key.to_s[-1] == '!'
              refute_includes actual.keys, key[0..-2], msg
              expected.delete(key)
            else
              assert_includes actual.keys, key, msg
              evaluate_contents_hash(dir, file, value, actual.dup[key])
            end
          when String

            if value.to_s[-1] == '!'
              refute_equal actual[key], value[0..-2], msg
            else
              msg = "Missing value #{value} for :#{key} in file: #{file}"
              assert_equal actual[key], value, msg
            end

          when Array
            value.each do |item|
              if item.to_s[-1] == '!'
                refute_includes actual[key], item[0..-2], msg
              else
                msg = "Missing item #{item} under :#{key} in file: #{file}"
                raise "#{file} #{dir} #{key} #{item}" unless actual[key]
                assert_includes actual[key], item, msg
              end
            end
          end
        end
      end

      def assert_correct_manifest(dir)
        story = RollonTestHelper.new(dir, rollon_options)
        story.rollon
        foo = story.manifest_for_story
        foo.each do |key, content|
          file = key.to_s
          if file[-1].eql?('!')
            refute_file(file[1..-2])
            next
          else
            assert_file(file)
          end
          case content
          when Array
            evaluate_contents_array(dir, file, content)
          when Hash
            evaluate_contents_hash(dir, file, content)
          end
        end
      end

      def evaluate_manifest_file_existence(f)
        f[-1].eql?('!') ? refute_file(f[0..-2]) : assert_file(f)
      end

      def stubs_answer(answer)
        Thor::Shell::Basic.any_instance
                          .stubs(:ask)
                          .returns(answer)
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
