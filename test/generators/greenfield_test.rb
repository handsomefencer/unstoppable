require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given do
    case
    when Dir.pwd.split('roro').last.match("/tmp/dummy")
      Dir.chdir('../')
    when Dir.pwd.split('roro').last.match("/tmp/greenfield")
      Dir.chdir('../')
    when Dir.pwd.split('/').last.match(/roro/)
      Dir.chdir('tmp')
    end
    %w(dummy greenfield).each do |directory|
      FileUtils.rm_rf(directory) if File.exist?(directory)
      FileUtils.mkdir_p(directory)
      FileUtils.copy_entry "../test/dummy", "dummy"
    end
    Dir.chdir 'greenfield'
  end

  describe "prepare" do

    # Given { prepare }

    Then { Dir.pwd.split('roro').last.must_equal "/tmp/greenfield" }
    And { Dir.empty?(Dir.pwd).must_equal true}
  end

  describe "usage" do

    # Given { prepare }
    Given { subject.greenfield }

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
