# frozen_string_literal: true

require 'pry'
require 'byebug'

Pry.config.input = STDIN
Pry.config.output = STDOUT

minitest_options = {
  test_folders: ['test'],
  # cli: '--profile',
  all_after_pass: false,
  all_on_start: false,
  all_env: {
    # 'DEBUGGERER' => 'true'
    'DEBUGGERER' => 'false'
  }
}

guard :minitest, minitest_options do
  stack_tests = 'test/roro/stacks'
  watch(%r{^#{stack_tests}/(.*)/?(.*)_test\.rb$})
  watch(%r{^#{stack_tests}/_manifest\.yml$}) { 'test' }

  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch(%r{^test/(.*)/?(.*)/shared_tests\.rb$}) { |m| "test/#{m[1]}" }

  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
  watch(%r{^test/helpers/(.*)\.rb$}) { ['test'] }
end
