# frozen_string_literal: true

module Minitest
  class Spec
    before do
      if defined? workbench
        prepare_destination(*workbench)
        Dir.chdir("#{@tmpdir}/workbench")
        @tmpdir_glob = Dir.glob("#{@tmpdir}/workbench/**/*")
      end
    end

    def assert_asked(prompt, choices, answer)
      Thor::Shell::Basic.any_instance
        .expects(:ask)
        .with(prompt, {:limited_to => choices.keys })
        .returns(choices[answer])
    end

    def prepare_destination(*workbench)
      @tmpdir = Dir.mktmpdir
      FileUtils.mkdir_p("#{@tmpdir}/workbench")
      workbench.each do |dummy_app|
        source = Dir.pwd + "/test/dummies/#{dummy_app}"
        if File.exist?(source)
          FileUtils.cp_r(source, "#{@tmpdir}/workbench")
        else
          FileUtils.mkdir_p("#{@tmpdir}/workbench/#{dummy_app}")
        end
      end
    end

    after do
      Dir.chdir ENV['PWD'] if defined? workbench
    end
  end
end
