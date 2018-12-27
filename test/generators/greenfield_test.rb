require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

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
