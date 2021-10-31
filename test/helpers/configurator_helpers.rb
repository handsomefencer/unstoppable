# frozen_string_literal: true

module Minitest
  class Spec

    def stubs_dependency_met?(dependency, value = false)
      Roro::Configurators::Configurator
        .any_instance
        .stubs(:dependency_met?)
        .with(dependency)
        .returns(value)
    end

    def stubs_yes?(value = true)
      Thor::Shell::Basic
        .any_instance
        .stubs(:yes?)
        .returns(value)

    end

    def stub_run_actions
      Roro::Configurators::AdventureWriter
        .any_instance
        .stubs(:run)
    end

    def stub_adventure
      Roro::Configurators::AdventurePicker
        .any_instance
        .stubs(:ask)
        .returns(*adventures)
    end

    def stub_journey(answers)
      Thor::Shell::Basic
        .any_instance
        .stubs(:ask)
        .returns(*answers)
    end

    def stub_rollon
      stub_adventure
      stub_overrides
    end

    def stub_overrides(answer='')
      Roro::Configurators::QuestionAsker
        .any_instance
        .stubs(:confirm_default)
        .returns(*overrides).then.returns(answer)
    end

    def stub_env_default
      Roro::Configurators::QuestionAsker
        .any_instance
        .stubs(:confirm_default)
        .returns('y')
    end

    def stub_answers_env(answer = 'y')
      Roro::Configurators::QuestionAsker
        .any_instance
        .stubs(:confirm_default)
        .returns(answer)
    end

    def stack_path(args = nil )
      append = defined?(stack) ? "/#{stack}" : nil
      prepend_valid = args.eql?(:invalid) ? 'invalid' : 'valid'
      stack_root ||= "#{fixture_path}/stack/#{prepend_valid}"
      "#{stack_root}#{append}"
    end

    def fixture_path
      "#{Dir.pwd}/test/fixtures"
    end

    def assert_valid_stack
      assert_nil validator.validate(stack_path)
    end

    def assert_question_asked(*question, answer)
      Thor::Shell::Basic.any_instance
                        .stubs(:ask)
                        .with(*question)
                        .returns(answer)
    end

    def assert_inflections(inflections)
      inflections.each { |item|
        builder = QuestionBuilder.new(inflection: "#{stack_path}/#{item[0]}")
        builder.build_inflection
        question = builder.question
        inflection_options = builder.inflection_options
        assert_question_asked(question, inflection_options.key(item[1])) }
    end

    def assert_itinerary_in(matchers, itineraries)
      is_present = itineraries.any? do |itinerary|
        matches = []
        matchers.each do |matcher|
          matches << matcher if file_match_in_files?(matcher, itinerary)
        end
        true if matches.size.eql?(matchers.size)
      end
      assert is_present, "'...#{matchers}' not found in itineraries: #{itineraries}"
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
  end
end
