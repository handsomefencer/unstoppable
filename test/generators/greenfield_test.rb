require "test_helper"

describe Roro::CLI do
  Given { skip }

  Given(:subject) { Roro::CLI.new }

  Given { prepare_destination 'greenfield' }

  describe "dependencies" do

    Given(:error) { Roro::Error }
    Given { FileUtils.rm('.keep') }

    describe "when not empty" do

      Given { FileUtils.touch("blah.txt")  }

      Then { assert_raises( error ) { subject.confirm_dependencies } }
    end
  end

  describe "usage" do

    Given { subject.copy_greenfield_files }

    describe "must generate files" do

      Then do

        generated_files = [
          "Gemfile",
          "config/database.yml.example",
          "Dockerfile",
          "docker-compose.yml",
          "Gemfile.lock"
        ]
        generated_files.each do |generated_file|

          assert_file generated_file
        end
      end
    end
  end
end
