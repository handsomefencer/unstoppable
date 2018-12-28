require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given(:prepare) {
    prepare_destination
    # FileUtils.copy_entry "../test/dummy", "dummy"
    Dir.chdir 'greenfield'
  }

  describe "prepare" do

    Given { prepare }
    Then { Dir.pwd.split('roro').last.must_equal "/tmp/greenfield" }
    And { Dir.empty?(Dir.pwd).must_equal true}
  end

  # Given {
  #   Dir.chdir('../') if Dir.pwd.match /greenfield/
  #   prepare_destination
  #
  #   Dir.chdir 'tmp/greenfield'
  # }
  #
  describe "usage" do

    Given { prepare }
    Given { subject.greenfield }
  #
    # generated_files = %w( )
    describe "must generate files" do

      Then do

        generated_files = %w( Gemfile docker-compose.yml Dockerfile Gemfile.lock)
        generated_files.each do |generated_file|

          assert_file generated_file
        end

        assert_file 'config/database.example.yml'
      end
    end
  end
end
