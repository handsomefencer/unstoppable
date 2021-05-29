# frozen_string_literal: true

module Minitest
  class Spec
    before do
      Thor::Shell::Basic.any_instance.stubs(:ask).returns('y')
      prepare_destination(*dummy_apps)
      Dir.chdir("#{@tmpdir}/workbench")
    end

    after do
      Dir.chdir ENV['PWD']
    end
  end
end
