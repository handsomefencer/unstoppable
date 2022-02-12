# frozen_string_literal: true

module Minitest
  class Spec

    def glob_dir(regex=nil)
      Dir.glob("#{Dir.pwd}/**/*")
    end

    def fixture_file_content(filename)
      File.read("#{@roro_dir}/test/fixtures/files/#{filename}")
    end

    def copy_stage_dummy(path)
      FileUtils.cp_r("#{path}/dummy/.", Dir.pwd )
    end

    def stubs_yes?(answer = 'yes')
      Thor::Shell::Basic.any_instance
                        .stubs(:yes?)
                        .returns(answer)
    end

    def save_result(result, location = nil )
      File.open("#{@roro_dir}/test/fixtures/files/#{location}", "w") do |f|
        f.write(result)
      end
    end

    def rollon(dir)
      workbench
      stubs_adventure(dir)
      stubs_dependencies_met?
      stubs_yes?
      stub_overrides
      copy_stage_dummy(dir) unless @rollon_dummies
      stub_run_actions unless @rollon_dummies
      if @rollon_dummies
        ENV['RORO_DOCUMENT_LAYERS'] = 'true'
      end
      cli = Roro::CLI.new
      @rollon_loud ? cli.rollon : quiet { cli.rollon }
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

    def run_rollon
      @build_dummies ? debug_rollon : simulate_rollon
    end

    def simulate_rollon
      stub_run_actions
      cli = Roro::CLI.new
      @rollon_loud ? cli.rollon : quiet { cli.rollon }
    end

    def debug_rollon
      cli = Roro::CLI.new
      @rollon_loud ? cli.rollon : quiet { cli.rollon }
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

    def stubs_adventure(path = nil, adventure = nil )
      adventure ||= path.split('/').last.to_i
      story = path.split("#{Roro::CLI.stacks}/").last
      case_builder = AdventureCaseBuilder.new
      case_builder.build_cases
      adventures = adventures_from(story.split('/test').first)[adventure]
      Roro::Configurators::AdventurePicker
        .any_instance
        .stubs(:ask)
        .returns(*adventures)
    end

    def adventures_from(stack)
      reflector  = Roro::Reflector.new
      adventures = []
      itineraries = []
      reflector.itineraries.each_with_index do |itinerary, index|
        if itinerary.any? { |itin| itin.match?(stack) }
          adventures << reflector.cases[index]
          itineraries << reflector.itineraries[index]
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
      overrides = @overrides || []
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
      "#{Roro::CLI.test_root}/fixtures"
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
