require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given(:prepare) do
    prepare_destination
    Dir.chdir 'greenfield'
  end

  describe "usage" do

    Given { prepare }
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
