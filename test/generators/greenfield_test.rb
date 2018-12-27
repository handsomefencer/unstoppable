require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given { prepare_destination }

  Given { Dir.chdir 'greenfield'}

  Given { subject.greenfield }

  generated_files = %w( docker-compose.yml Dockerfile Gemfile.lock)
  generated_files.each do |generated_file|

    describe "must generate #{generated_file}" do

      Then do

        assert_file generated_file
      end
    end
  end
end
