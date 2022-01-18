# frozen_string_literal: true

require 'rake'
module Roro
  module TestHelpers
    module RakeTaskHelpers

      def run_task(task_name)
        loc = 'test/fixtures/matrixes'
        FileUtils.cp_r("#{@roro_dir}/test", "#{Dir.pwd}")
        @task_name = task_name
        @output = capture_subprocess_io { Rake::Task[task_name].execute }
      end
    end

    module AdventureHelper

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
    end
  end
end

module Minitest
  class Spec

    include Roro::TestHelpers::AdventureHelper
    include Roro::TestHelpers::RakeTaskHelpers

    def check_into_workbench
      return unless defined? workbench
      Rake.application.load_rakefile
      prepare_destination(*workbench)
      @roro_dir = Dir.pwd
      Dir.chdir("#{@tmpdir}/workbench")
      @tmpdir_glob = Dir.glob("#{@tmpdir}/workbench/**/*")
    end

    def check_out_of_workbench
      Dir.chdir ENV['PWD'] if defined? workbench
    end

    before do
      cases_cache(Dir.pwd)
      check_into_workbench
    end

    after do
      check_out_of_workbench
    end
  end
end
