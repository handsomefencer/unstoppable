# frozen_string_literal: true

require 'rake'

module Roro
  module TestHelpers
    module RakeTaskTestHelper
      def run_task(*args)
        loc = 'test/fixtures/matrixes'
        FileUtils.mkdir_p("#{Dir.pwd}/#{loc}")
        FileUtils.cp_r("#{@roro_dir}/#{loc}/.", "#{Dir.pwd}/#{loc}")
        @task_name = args.shift
        getsome = Rake::TaskArguments.new([:matchers], [args.last])
        @output =  Rake::Task[@task_name].execute(getsome)
      end
    end
  end
end
