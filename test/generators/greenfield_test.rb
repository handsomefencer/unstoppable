require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given(:prepare) {
    prepare_destination
    # FileUtils.copy_entry "../test/dummy", "dummy"
    Dir.chdir 'greenfield'
    puts Dir.pwd.upcase
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
    generated_files = %w( Gemfile docker-compose.yml Dockerfile Gemfile.lock)
    generated_files.each do |generated_file|

      describe "must generate #{generated_file}" do

        Then do

          assert_file generated_file
        end
      end
    end
  end
end
