require 'pry'
require 'byebug'

Pry.config.input = STDIN
Pry.config.output = STDOUT

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

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

  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch(%r{^test/(.*)/?(.*)/shared_tests\.rb$}) { |m| "test/#{m[1]}" }

  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
  watch(%r{^test/helpers/(.*)\.rb$}) { ['test'] }
end
