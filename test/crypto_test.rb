require "test_helper"

describe Roro::Crypto do
  Given { prepare_destination 'crypto' }
  Given { ENV['DUMMY_KEY'] = nil }

  Given(:subject) { Roro::Crypto }
  Given(:env_var) { 'export FOO=bar' }

  describe ':generate_key' do

    Then { assert_equal subject.generate_key.size, 25 }
  end

  describe ":write_to_file(data, filename)" do
    Given(:write_to_file) { -> (file) { subject.write_to_file(env_var, file) } }

    context 'when .txt extension' do

      Given { write_to_file['example.txt'] }

      Then { assert_equal File.read('example.txt'), "export FOO=bar"}
    end

    context 'when .env extension' do
      Given { write_to_file['example.env']}

      Then { assert_equal File.read('example.env'), "export FOO=bar"}
    end

    context 'when file exists extension' do

      Given { write_to_file['example.env'] }

      Then { assert_equal File.read('example.env'), "export FOO=bar"}
    end

    context 'when file exists in same location' do
      Given(:error) { assert_raises(Roro::Crypto::DataDestructionError) {
        insert_file 'dummy_key', file
        write_to_file[file] } }

      context 'when .key file' do
        Given(:file) { './roro/keys/dummy.key'}
        Then { assert_match "#{file} exists", error.message }
      end

      context 'when .env file' do
        Given(:file) { './roro/env/dummy.env'}
        Then { assert_match "#{file} exists", error.message }
      end

      context 'when .env.enc file' do
        Given(:file) { './roro/env/dummy.env.enc'}
        Then { assert_match "#{file} exists", error.message }
      end
    end
  end

  describe ":write_key_to_file(target_directory, key_name)" do

    Given { subject.write_key_to_file('roro/keys', "deploy") }

    Then  { assert_equal File.read('./roro/keys/deploy.key').size, 25 }
  end

  describe ":source_files" do

    Given { insert_file 'dummy_env', destination }
    Given(:pattern)      { '.env.fixture' }
    Given(:source_files) { subject.source_files(destination_dir, '.env' ) }
    Given(:destination)     { destination_dir + '/dummy.env' }

    context 'when not in ./roro/' do
      Given(:error) { Roro::Crypto::SourceDirectoryError }

      context 'when in base directory' do
        When(:destination_dir) { './' }
        Then { assert_raises(error) { source_files } }
      end

      context 'when roro is not first folder in path' do
        When(:destination_dir) { './not_roro' }
        Then { assert_raises(error) { source_files } }
      end
    end

    context 'when in base directory of ./roro' do
      When(:destination_dir) { './roro' }

      Then { assert_includes source_files, destination }
    end

    context 'when nested one level' do
      When(:destination_dir) { './roro/containers' }

      Then { assert_includes source_files, destination }
    end

    context 'when nested two levels' do
      When(:destination_dir) { './roro/containers/app' }

      Then { assert_includes source_files, destination }
    end

    context 'when nested three levels' do
      When(:destination_dir) { './roro/containers/database/env' }

      Then { assert_includes source_files, destination }
    end
  end

  describe ":get_key" do
    Given(:key_from_env)    { "s0m3k3y-fr0m-variable" }
    Given(:key_in_key_file) { insert_file 'dummy_key', './roro/keys/dummy.key' }

    context 'when key is not set' do
      Given(:get_key) {  subject.get_key('dummy') }

      describe 'must return error' do

        Then { assert_raises(Roro::Crypto::KeyError) { get_key } }
      end

      describe 'returned error message' do
        Given(:error) { assert_raises(Roro::Crypto::KeyError) { get_key } }

        Then { assert_match 'No DUMMY_KEY set', error.message }
      end
    end

    context 'when key set in' do
      context 'an environment variable' do
        Given { ENV['DUMMY_KEY'] = "s0m3k3y-fr0m-variable" }

        Then { assert_equal subject.get_key('dummy'), key_from_env }
      end

      context 'an environment variable and in a key file' do
        Given { ENV['DUMMY_KEY'] = "s0m3k3y-fr0m-variable" }
        Given { key_in_key_file }

        Then  { assert_equal subject.get_key('dummy'), key_from_env }
      end

      context 'in a key file' do
        Given { key_in_key_file }
        Given(:key_from_file) { 'XLF9IzZ4xQWrZo5Wshc5nw==' }

        Then { assert_equal subject.get_key('dummy'), key_from_file }
      end
    end
  end

  describe ":encrypt(file, key)" do

    Given(:encrypt) { -> (file) {
      insert_file 'dummy_env', file
      subject.encrypt(file, 'dummy') } }

    Given { insert_file 'dummy_key', 'roro/keys/dummy.key'}

    context 'when file is in ./roro/' do

      Given { encrypt['./roro/dummy.env'] }

      Then  { assert File.exist? './roro/dummy.env.enc' }
    end

    context 'when file is in ./roro/containers/' do

      Given { encrypt['./roro/containers/dummy.env'] }

      Then  { assert File.exist? './roro/containers/dummy.env.enc' }
    end

    context 'when file is a subenv' do

      Given { encrypt['./roro/containers/dummy.subenv.env'] }

      Then  { assert File.exist? './roro/containers/dummy.subenv.env.enc' }
    end
  end

  describe ":decrypt(file, key)" do
    Given(:decrypt) { -> (file) {
      insert_file 'dummy_env_enc', file
      subject.decrypt(file, 'dummy') } }

    Given { insert_file 'dummy_key', 'roro/keys/dummy.key'}


    # Given { insert_file 'dummy_env_enc', './roro/env/dummy.env.enc' }
    # Given { insert_file 'dummy_key', './roro/keys/dummy.key' }

    # Given(:assert_encrypted_file) { -> (file) {
    #   assert File.exist?(file) } }

    # Then { assert_encrypted_file['./roro/env/dummy.env.enc'] }
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
    # end
  end
end