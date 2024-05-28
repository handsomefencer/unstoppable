# frozen_string_literal: true

module Roro::TestHelpers::StackTestHelper

  def use_fixture_stack(stack = nil)
    return unless stack

    fixture_stacks = 'fixtures/files/stacks'
    Roro::CLI
      .stubs(:stacks)
      .returns("#{Roro::CLI.test_root}/#{fixture_stacks}/#{stack}")
  end

  def prepare_destination(*workbench)
    @tmpdir = Dir.mktmpdir
    FileUtils.mkdir_p("#{@tmpdir}/workbench")
    workbench.each do |dummy_app|
      source = Dir.pwd + "/test/fixtures/dummies/#{dummy_app}"
      if File.exist?(source)
        FileUtils.cp_r(source, "#{@tmpdir}/workbench")
      else
        FileUtils.mkdir_p("#{@tmpdir}/workbench/#{dummy_app}")
      end
    end
  end

  def check_into_workbench
    return unless defined? workbench

    # Rake.application.load_rakefile
    prepare_destination(*workbench)
    @roro_dir = Dir.pwd
    Dir.chdir("#{@tmpdir}/workbench")
    @tmpdir_glob = Dir.glob("#{@tmpdir}/workbench/**/*")
  end

  def check_out_of_workbench
    Dir.chdir ENV['PWD'] if defined? workbench
  end
end
