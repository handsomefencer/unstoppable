<<<<<<< HEAD
=======
require 'byebug'
>>>>>>> dummy
require "test_helper"

describe Roro::CLI do

<<<<<<< HEAD
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
=======
  Given {
    gem_root = Gem::Specification.find_by_name('roro').gem_dir
    Dir.chdir File.join(gem_root, 'tmp') }
  Given(:subject) { Roro::CLI.new }

  Given { FileUtils.rm_rf 'greenfield'}
  Given { FileUtils.mkdir_p 'greenfield'}
  Given { Dir.chdir 'greenfield'}
  Given { subject.greenfield }

  generated_files = %w( docker-compose.yml)

  # describe "must create necessary files" do

    Then do

      generated_files.each do |generated_file|
        assert_file generated_file
      end
    end
  end
# end
>>>>>>> dummy
