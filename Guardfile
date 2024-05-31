# frozen_string_literal: true
require 'debug'
minitest_options = {
  test_folders: ['test'],
  # test_file_patterns: [
  #   "roro/stacks/**/*_test.rb",
  #   "test_helper_tests/**/*_test.rb",
  # ],
  all_after_pass: false,
  all_on_start: false,
  all_env: {
    'DEBUGGERER' => 'false'
  }
}

guard :minitest, minitest_options do

  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch(%r{^test/(.*)/?(.*)/shared_tests\.rb$}) { |m| "test/#{m[1]}" }

  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
  watch(%r{^test/helpers/(.*)\.rb$}) { ['test'] }
  watch(%r{^test/test_helpers/reflection_helper\.rb$}) { |m| 'test/roro/configurators/stack_reflector' }
  watch(%r{^test/test_helpers/configurator_test_helper\.rb$}) { 'test' }

  watch(%r{^test/test_helpers/(.*)_helper\.rb$}) { |m| "test/test_helpers/test/#{m[1]}_helper_test.rb"}

  watch(%r{^test/roro/(.+)/_manifest(.*)\.yml$})     {  "test/roro/stacks" }
end
