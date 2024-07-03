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
        # @output =  Rake::Task[args.shift].execute({matchers: args})
        # debugger
        getsome = Rake::TaskArguments.new([:matchers], [args.last])
        @output =  Rake::Task[@task_name].execute(getsome)
                # @output =  Rake::Task["#{task_name}\[\"#{args}\"\]"].execute

        # @output = capture_subprocess_io { Rake::Task[task_name].execute(args) }
      end
    end
  end
end
