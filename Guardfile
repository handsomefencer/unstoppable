# A sample Guardfile
# More info at https://github.com/guard/guard#readme

options = {
  cli: '',
  all_after_run: true,
  all_after_pass: true
}

guard :minitest, options do

  watch(%r{^test/(.*)\/?test_(.*)\.rb$})
  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^lib/roro/cli/(.+)\.rb$}) { |m| "test/generators/#{m[1]}_test.rb" }

  watch(%r{^test/thor_helper\.rb$})      { 'test' }

  watch(%r{^test/fixtures/files/(.*/)?([^/]+)\.yml$})     { 'test' }

end
