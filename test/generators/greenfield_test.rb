require "test_helper"

describe Roro::CLI do

  # let(:subject) { Roro::CLI.new }

  before do
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
    @subject = Roro::CLI.new
  end

  it "prepare" do

     Dir.pwd.split('roro').last.must_equal "/tmp/greenfield"
     Dir.empty?(Dir.pwd).must_equal true
  end

  generated_files = %w( Gemfile docker-compose.yml Dockerfile Gemfile.lock)
  generated_files.each do |generated_file|

    it "must generate #{generated_file}" do

      @subject.greenfield
      assert_file generated_file
    end
  end
end
