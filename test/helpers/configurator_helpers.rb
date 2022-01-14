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

    def case_from_path(stack, array = nil)
      if @case.nil?
        @case = []
        array = stack.split("#{@stack}/").last.split('/')
        stack = @stack
      end
      folder = array.shift
      stack = "#{stack}/#{folder}"
      @case << folder if stack_is_adventure?(stack)
      case_from_path(stack, array) unless array.empty?
      @case
    end

    def case_from_stack(stack)
      hash = cases
      case_from_path(stack).map do |item|
        _index = hash.keys.index(item.to_sym)
        hash = hash[item.to_sym]
        _index += 1
      end
    end

    def stubs_adventure(path = nil)
      case_builder = AdventureCaseBuilder.new
      case_builder.build_cases
      adventures = adventures_from(path.split('/test').first).first
      Roro::Configurators::AdventurePicker
        .any_instance
        .stubs(:ask)
        .returns(*adventures)
    end

    def cases_cache(context = Dir.pwd)
      fixtures    = "#{context}/test/fixtures/matrixes"
      @matrix ||= {
        cases: read_yaml("#{fixtures}/cases.yml"),
        itineraries: read_yaml("#{fixtures}/itineraries.yml")
      }
    end

    def adventures_from(stack)
      adventures  = []
      cases_cache
      @matrix[:itineraries].each_with_index do |itinerary, index|
        if itinerary.include?(stack)
          adventures << @matrix[:cases][index]
        end
      end
      adventures
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

    def generate_fixtures
      capture_subprocess_io {
        generate_fixture_cases
        generate_fixture_itineraries
      }
    end

    def generate_fixture_cases
      File.open(cases_loc, "w+") { |f|
        builder = Roro::Configurators::AdventureCaseBuilder.new
        f.write(builder.build_cases_matrix.to_yaml)
      }
    end

    def generate_fixture_itineraries
      File.open(itineraries_loc, "w+") do |f|
        itineraries = []
        cases.each do |c|
          Roro::Configurators::AdventurePicker
            .any_instance
            .stubs(:ask)
            .returns(*c)
          chooser = AdventureChooser.new
          chooser.build_itinerary
          itineraries << chooser.itinerary
        end
        f.write(itineraries.to_yaml)
      end
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
