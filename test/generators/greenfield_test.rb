require 'byebug'
require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given {
    FileUtils.rm_rf('tmp/.')
    Dir.chdir('tmp') unless Dir.pwd.match /roro\/tmp/ }

  Given { subject.greenfield }

  generated_files = %w( docker-compose.yml)

  describe "must create necessary files" do

    Then do
      generated_files.each do |generated_file|
        assert_file generated_file
      end
    end
  end
end
