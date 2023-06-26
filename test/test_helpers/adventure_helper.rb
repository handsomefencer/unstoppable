# frozen_string_literal: true

require 'rake'
module Roro
  module TestHelpers
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
