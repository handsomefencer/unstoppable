# frozen_string_literal: true

module Roro::TestHelpers::FileAssertionsTestHelper
  def globdir(regex = nil, path=nil)
    regex ||= '**/*'
    string = path ? "#{path}/#{regex}" : regex
    Dir.glob(string)
  end

  def copy_with_path(src, dst)
    FileUtils.mkdir_p(File.dirname(dst))
    FileUtils.cp(src, dst)
  end

  def assert_file_match_in(file_matcher, files)
    msg = "'...#{file_matcher}' doesn't match any files in: #{files}"
    assert(files.any? { |file| file.match file_matcher }, msg)
  end



  def assert_file(file)
    assert(File.exist?(file), "Expected #{file} in #{globdir}")
  end

  def assert_content(file, *contents)
    assert_file(file)
    evaluate_content(true, file, *contents)
  end

  def refute_file(file, *contents)
    refute(File.exist?(file), "Did not expect #{file} to exist")

    evaluate_content(false, file, *contents)
  end

  def refute_content(file, *contents)
    evaluate_content(false, file, *contents)
  end

  def evaluate_content(*args)
    boolean, file = args.shift, args.shift
    read = File.read(file) if block_given? || !args.empty?
    yield read if block_given?
    args.each do |content|
      args = [content, read]
      case content
      when String
        boolean ? assert_equal(*args) : refute_equal(*args)
      when Regexp
        boolean ? assert_match(*args) : refute_match(*args)
      end
    end
  end

  alias assert_directory assert_file

  def assert_yaml(*args)
    evaluate_yaml(true, *args)
  end

  def refute_yaml(*args)
    evaluate_yaml(false, *args)
  end

  def evaluate_yaml(*args)
    boolean, file = args.shift, args.shift
    assert_file(file)
    yaml = read_yaml(file)
    expected = args.pop
    case expected
    when String
      args = [expected, yaml.dig(*args)]
      boolean ? assert_equal(*args) : refute_equal(*args)
    when Regexp
      args = [expected, yaml.dig(*args)]
      boolean ? assert_match(*args) : refute_match(*args)
    when Hash
      if expected.values.first.is_a?(Array)
      else
        args = [yaml, yaml.deep_merge(expected)]
        boolean ? assert_equal(*args) : refute_equal(*args)
      end
    end
  end
end
