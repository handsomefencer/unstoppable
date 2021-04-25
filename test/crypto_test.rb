require "test_helper"

describe Roro::Crypto do
  Given { prepare_destination 'crypto' }

  Given(:subject) { Roro::Crypto }
  Given(:env_var) { 'export FOO=bar' }

  describe ':generate_key' do

    Then { assert_equal subject.generate_key.size, 25 }
  end

  describe ":write_to_file(data, filename)" do
    Given { subject.write_to_file(env_var, filename) }

    context 'when .txt extension' do

      When(:filename) { 'example.txt' }

      Then { assert_equal File.read('example.txt'), "export FOO=bar"}
    end

    context 'when .env extension' do

      When(:filename) { 'example.env' }

      Then { assert_equal File.read('example.env'), "export FOO=bar"}
    end
  end

  describe ":write_key_to_file(target_directory, key_name)" do

    Given { subject.write_key_to_file('roro/keys', "deploy") }

    Then { assert_equal File.read('./roro/keys/deploy.key').size, 25 }
  end

  describe ":source_files" do

    Given { insert_file 'dummy_env', expected }
    Given(:pattern)      { '.env.fixture' }
    Given(:source_files) { subject.source_files('.', '.env' ) }
    Given(:expected)     { destination_dir + 'dummy.env' }

    context 'when base directory of app' do
      When(:destination_dir) { './' }

      Then { assert_includes source_files, expected }
    end

    context 'when nested one level' do
      When(:destination_dir) { './roro/' }

      # Then { source_files.must_include expected }
    end

    context 'when nested two levels' do
      When(:destination_dir) { './roro/containers/' }

      Then { assert_includes source_files, expected }
    end

    context 'when nested three levels' do
      When(:destination_dir) { './roro/containers/app/' }

      # Then { source_files.must_include expected }
    end
  end

  describe ":get_key" do
    Given(:key_from_env)    { "s0mk3y-fr0m-variable" }
    Given(:key_from_key_file)   { "s0mk3y-fr0m-keyfile" }
    Given(:key_in_key_file) {  insert_file 'dummy_key', './roro/keys/dummy.key'  }
    Given(:key_error) { Roro::Crypto::KeyError }

    describe 'when key is not set' do
      Given { ENV['DUMMY_KEY'] = nil }

      Then { assert_raises(key_error) { subject.get_key('dummy') } }
    end

    describe 'when key is set' do
      describe 'in an environment variable' do
        Given { ENV['DUMMY_KEY'] = "s0mk3y-fr0m-variable" }

        Then  { assert_equal subject.get_key('dummy'), key_from_env }

        context 'in an environment variable and in a key file' do
          Given { key_in_key_file }

          Then  { assert_equal subject.get_key('dummy'), key_from_env }
        end
      end

      context 'in a key file' do
        Given { ENV['DUMMY_KEY'] = nil }
        Given { key_in_key_file }

        Then  { assert_equal subject.get_key('dummy'), key_from_key_file }
      end
    end
  end

  describe ":encrypt(file, key)" do
    context 'when file is in ./roro/' do
      Given { insert_file 'dummy_env', './roro/dummy.env' }
    end
    Given { insert_file 'dummy_key', './roro/keys/dummy.key' }
    Given { subject.encrypt('./roro/dummy.env', 'dummy')}

    # Then { assert File.exist? './roro/dummy.env.enc' }

    describe ":decrypt(file, key)" do

      Given { File.delete('./roro/dummy.env') }
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