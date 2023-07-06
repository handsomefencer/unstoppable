# frozen_string_literal: true

module Roro::TestHelpers::ConfiguratorHelper
  def glob_dir(regex = '**/*')
    Dir.glob("#{Dir.pwd}/#{regex}")
  end

  def use_fixture_stack(stack = nil)
    return unless stack

    fixture_stacks = 'fixtures/files/stacks'
    Roro::CLI
      .stubs(:stacks)
      .returns("#{Roro::CLI.test_root}/#{fixture_stacks}/#{stack}")
  end

  def fixture_file_content(filename)
    File.read("#{@roro_dir}/test/fixtures/files/#{filename}")
  end

  def copy_stage_dummy(path)
    FileUtils.cp_r("#{path}/dummy/.", Dir.pwd)
  end

  def stubs_yes?(answer = 'yes')
    Thor::Shell::Basic.any_instance
                      .stubs(:yes?)
                      .returns(answer)
  end

  def capture_stage_dummy(dir)
    dummy_dir = "#{dir}/dummy"
    dummies = Dir.glob("#{dir}/dummy/**/*").map do |f|
      f.split("#{dummy_dir}/").last
    end
    dummies.each do |dummy|
      dummyfile = dummy.split(dummy_dir).last
      if File.file?("#{Dir.pwd}/#{dummyfile}") && File.file?(dummyfile)
        FileUtils.cp_r(dummyfile, "#{dummy_dir}/#{dummy}")
      end
    end
  end

  def debuggerer
    @rollon_dummies = true
    @rollon_loud = true
  end

  def rollon(dir)
    debuggerer if ENV['DEBUGGERER'].eql?('true')
    workbench
    stubs_adventure(dir)
    stubs_dependencies_met?
    stubs_yes?
    stub_overrides
    if @rollon_dummies.eql?(true)
      ENV['RORO_DOCUMENT_LAYERS'] = 'true'
    else
      copy_stage_dummy(dir)
      stub_run_actions
    end

    cli = Roro::CLI.new
    @rollon_loud ? cli.rollon : quiet { cli.rollon }
    capture_stage_dummy(dir) if @rollon_dummies.eql?(true)
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

  def stubs_adventure(path = nil, _adventure = nil)
    answers = infer_answers_from_testfile_location(path)
    Roro::Configurators::AdventurePicker
      .any_instance
      .stubs(:ask)
      .returns(*answers)
  end

  def infer_answers_from_testfile_location(path = nil)
    test_stack_root = "#{Roro::CLI.test_root}/roro/stacks"
    array = path.split("#{test_stack_root}/").last.split('/')
    reflector = Roro::Configurator::StackReflector.new
    reflector.adventures
             .select { |_k, v| v[:choices].eql?(array) }
             .values.first[:picks]
  end

  def stub_journey(answers)
    Thor::Shell::Basic
      .any_instance
      .stubs(:ask)
      .returns(*answers)
  end

  def stub_overrides(answer = '')
    overrides = @overrides || []
    Roro::Configurators::QuestionAsker
      .any_instance
      .stubs(:confirm_default)
      .returns(*overrides).then.returns(answer)
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
