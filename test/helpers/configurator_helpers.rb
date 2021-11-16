# frozen_string_literal: true

module Minitest
  class Spec

    def copy_stage_dummy(path)
      list = Dir.glob("#{path}/stage_dummy/**/*")
      FileUtils.cp_r(list, Dir.pwd )
    end

    def stubs_yes?(answer = 'yes')
      Thor::Shell::Basic.any_instance
                        .stubs(:yes?)
                        .returns(answer)
    end

    def stubs_answer(answer)
      Thor::Shell::Basic.any_instance
                        .stubs(:ask)
                        .returns(answer)
    end

    def stubs_dependencies_met?(value = false)
      Roro::Configurators::Configurator
        .any_instance
        .stubs(:dependency_met?)
        .returns(value)
    end

    def stub_run_actions
      Roro::Configurators::AdventureWriter
        .any_instance
        .stubs(:run)
    end

    def stubs_adventure(path = nil)
      case_builder = AdventureCaseBuilder.new
      case_builder.build_cases
      adventures = case_builder.case_from_path(path)
      Roro::Configurators::AdventurePicker
        .any_instance
        .stubs(:ask)
        .returns *journey_choices(*adventures.map(&:to_sym))
    end

    def journey_choices(*args)
      cases = read_yaml("#{Roro::CLI.test_root}/helpers/adventure_cases.yml")
      builder = AdventureCaseBuilder.new
      cases = builder.cases # read_yaml("#{Roro::CLI.test_root}/helpers/adventure_cases.yml")
      hash = args.last.is_a?(Hash) ? args.pop : cases
      return if hash.empty?
      choice = args.shift
      journey_choices(*(args << hash[choice]))
      (@array ||= []).insert(0, hash.keys.index(choice) + 1)
    end

    def stub_journey(answers)
      Thor::Shell::Basic
        .any_instance
        .stubs(:ask)
        .returns(*answers)
    end

    def stub_overrides(answer='')
      Roro::Configurators::QuestionAsker
        .any_instance
        .stubs(:confirm_default)
        .returns(*overrides).then.returns(answer)
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
