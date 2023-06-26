# frozen_string_literal: true

require 'rake'

module Roro
  module TestHelpers
    module RakeTaskHelper
      def run_task(task_name)
        loc = 'test/fixtures/matrixes'
        FileUtils.mkdir_p("#{Dir.pwd}/#{loc}")
        FileUtils.cp_r("#{@roro_dir}/#{loc}/.", "#{Dir.pwd}/#{loc}")
        @task_name = task_name
        @output = capture_subprocess_io { Rake::Task[task_name].execute }
      end
    end
  end
end
