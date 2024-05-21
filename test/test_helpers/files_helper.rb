# frozen_string_literal: true

module Roro::TestHelpers::FilesHelper
  def assert_file_match_in(file_matcher, files)
    msg = "'...#{file_matcher}' doesn't match any files in: #{files}"
    assert(files.any? { |file| file.match file_matcher }, msg)
  end

  def assert_file(file, *contents)
    actual = Dir.glob("#{Dir.pwd}/**/*")
    assert File.exist?(file), "Expected #{file} to exist, but does not. actual: #{actual[0]}"

    read = File.read(file) if block_given? || !contents.empty?
    yield read if block_given?
    contents.each do |content|
      case content
      when String
        assert_equal content, read
      when Regexp
        assert_match content, read
      end
    end
  end

  alias assert_directory assert_file

  def assert_yaml(*args)
    file = args.shift
    assert_file(file)
    yaml = JSON.parse(YAML.load_file(file, aliases: true).to_json, symbolize_names: true)
    expected = args.pop
    case expected
    when String
      assert_equal(expected, yaml.dig(*args))
    when Regexp
      assert_match(expected, yaml.dig(*args))
    when Hash
      if expected.values.first.is_a?(Array)
      else
        assert_equal(yaml, yaml.deep_merge(expected), msg: "#{expected} not found")
      end
    end
  end

  def refute_yaml(*args)
    file = args.shift
    assert_file(file)
    yaml = JSON.parse(YAML.load_file(file, aliases: true).to_json, symbolize_names: true)
    assert_nil yaml.dig(*args)
  end

  def refute_file(file, *_contents)
    refute File.exist?(file), "Expected #{file} to not exist, but it does."
  end

  def refute_content(file, content)
    assert_file(file)
    read = File.read(file)
    yield read if block_given?
    case content
    when String
      refute_equal content, read
    when Regexp
      refute_match content, read
    end
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

  def insert_dummy_key(filename = 'dummy.key')
    insert_file 'dummy_key', "./roro/keys/#{filename}"
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
