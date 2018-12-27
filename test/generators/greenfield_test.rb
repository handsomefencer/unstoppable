require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given { prepare_destination }

  Given { subject.greenfield }

  generated_files = %w( docker-compose.yml  )

  generated_files.each do |generated_file|

    describe "must create #{generated_file}" do

      Then { assert_file generated_file }
    end
  end
end
