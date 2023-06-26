module Minitest
  class Spec
    include Roro::TestHelpers::AdventureHelper

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
      check_into_workbench
    end

    after do
      check_out_of_workbench
    end
  end
end
