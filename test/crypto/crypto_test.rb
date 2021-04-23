require "test_helper"
require "fileutils"

describe Roro::Crypto do
  Given { FileUtils.rm_rf(Dir[ 'tmp/*'] ) }

  Given(:subject) { Roro::Crypto }
  Given(:env_var) { 'export FOO=bar' }

  describe ":generate_key" do

    Then { subject.generate_key.size.must_equal 25 }
  end

  describe ":write_to_file(data, filename)" do

    Given { subject.write_to_file(env_var, 'tmp/example.txt')}

    Then { assert File.read('tmp/example.txt').must_equal "export FOO=bar"}
  end

  describe ":generate_key_file(target)" do

    Given { subject.generate_key_file('tmp', "deploy") }

    Then { assert_equal File.read('./tmp/deploy.key').size, 25 }
  end

  describe ":source_files" do
    context 'when .md extension' do 

      Given(:source_files) { subject.source_files('.', '.md') }

      Then { source_files.must_include "./README.md"}
    end
    
    context 'when .txt extension' do 

      Given(:source_files) { subject.source_files('.', '.txt') }

      Then { source_files.must_include "./LICENSE.txt"}
    end
    
    context 'when child directory' do 

      Given(:source_files) { subject.source_files('./sandbox/sandboxer', '.env') }

      Then { source_files.must_include "./production.env"}
    end
  end

  describe ":get_key" do

    Given(:env_key) { "some-long-key" }

    describe "when set as env variable" do

      Given { ENV['PRODUCTION_KEY'] = env_key }

      # Then { assert_equal env_key, subject.get_key('production') }
    end

    describe "when read from file" do

      Given { ENV['PRODUCTION_KEY'] = nil }
      Given { subject.generate_key_file('tmp', 'production') }
      Given(:key_from_file) { File.read('./tmp/production.key').strip }

      # Then {  assert_equal key_from_file, subject.get_key('production') }
    end
  end

  describe ":encrypt(file, key)" do

    Given { subject.write_to_file(env_var, 'tmp/production.env')}
    Given { subject.generate_key_file('tmp', 'production') }
    Given { subject.encrypt('tmp/production.env', 'production')}

    # Then { assert File.exist? 'tmp/production.env.enc' }

    describe ":decrypt(file, key)" do

      Given { File.delete('tmp/production.env') }
      Given { refute File.exist?('tmp/production.env')  }
      Given { subject.decrypt('tmp/production.env.enc') }

      # Then { assert File.exist?('tmp/production.env')  }
    end
  end

  describe ":obfuscate(key, directory, extension" do

    Given(:enc_files) { subject.source_files('tmp', '.env.enc')}
    Given { FileUtils.mkdir_p('tmp/dokken/test' ) }
    Given { subject.write_to_file(env_var, 'tmp/dokken/production.env')}
    Given { subject.write_to_file(env_var, 'tmp/dokken/staging.env')}
    Given { subject.write_to_file(env_var, 'tmp/dokken/test/production.env')}
    Given { subject.generate_key_file('tmp', 'production') }
    Given { subject.generate_key_file('tmp', 'staging') }
    Given { enc_files.size.must_equal 0 }
    Given { subject.obfuscate('production', 'tmp') }

    # Then { assert enc_files.each { |ef| File.exist?(ef) } }
    # Then { refute File.exist? 'tmp/dokken/staging.env.enc' }

    describe "#expose(env, dir, ext)" do

      Given { subject.obfuscate('staging', 'tmp') }
      Given(:env_files) { subject.source_files('tmp', '.env') }
      Given { env_files.each { |file| File.delete file } }
      Given { env_files.each { |file| refute File.exist? file } }
      Given { subject.expose('production', 'tmp') }
      Given { subject.expose('staging', 'tmp') }

      # Then { env_files.each { |file| assert File.exist? file } }
    end
  end
end