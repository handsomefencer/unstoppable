# frozen_string_literal: true

require 'rake'

module Roro
  module TestHelpers
    module RakeTaskTestHelper
      def run_task(task_name, args=nil)
        loc = 'test/fixtures/matrixes'
        FileUtils.mkdir_p("#{Dir.pwd}/#{loc}")
        FileUtils.cp_r("#{@roro_dir}/#{loc}/.", "#{Dir.pwd}/#{loc}")
        @task_name = task_name
        # debugger
        @output =  Rake::Task[task_name].execute
                # @output =  Rake::Task["#{task_name}\[\"#{args}\"\]"].execute

        # @output = capture_subprocess_io { Rake::Task[task_name].execute(args) }
      end
    end
  end
end
