# frozen_string_literal: true

module Roro::TestHelpers::FilesTestHelper
  def globdir(regex = nil, path=nil)
    regex ||= '**/*'
    string = path ? "#{path}/#{regex}" : regex
    Dir.glob(string)
  end

  def copy_with_path(src, dst)
    FileUtils.mkdir_p(File.dirname(dst))
    FileUtils.cp(src, dst)
  end

  def insert_file(source, destination)
    source = [ENV.fetch('PWD'), 'test/fixtures/files', source].join('/')
    destination = [Dir.pwd, destination].join('/')
    FileUtils.cp(source, destination)
  end

  def insert_dummy_env(filename = 'roro/env/dummy.env')
    insert_dummy filename
  end

  def insert_dummy_env_enc(filename = 'roro/env/dummy.env.enc')
    insert_file 'dummy_env_enc', filename
  end

  def insert_dummy(filename = 'roro/env/dummy.env')
    insert_file 'dummy_env', filename
  end

  def insert_dummy_key(filename = 'dummy.key', keyholder="./roro/keys")
    insert_file 'dummy_key', "#{keyholder}/#{filename}"
  end

  def dummy_key
    'XLF9IzZ4xQWrZo5Wshc5nw=='
  end

  def insert_key_file(filename = 'dummy.key')
    insert_file 'dummy_key', "./roro/keys/#{filename}"
  end

  def assert_correct_error
    expected_error = defined?(error) ? error : Roro::Error
    returned = assert_raises(expected_error) { execute }
    assert_match error_msg, returned.message
  end

  def with_env_set(options = nil, &block)
    ClimateControl.modify(options || { DUMMY_KEY: var_from_ENV }, &block)
  end
end
