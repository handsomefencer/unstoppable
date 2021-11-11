# frozen_string_literal: true

module Roro
  module TestHelpers
    module AdventureHelper

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
    end
  end
end

module Minitest
  class Spec
    include Roro::TestHelpers::AdventureHelper
    before do
      if defined? workbench
        prepare_destination(*workbench)
        @roro_dir = Dir.pwd
        Dir.chdir("#{@tmpdir}/workbench")
        @tmpdir_glob = Dir.glob("#{@tmpdir}/workbench/**/*")
      end
    end


    after do
      Dir.chdir ENV['PWD'] if defined? workbench
    end
  end
end
