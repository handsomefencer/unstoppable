options = {
  all_on_start: false,
  all_after_pass: true, 
}

guard :minitest, options do

  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^test/helpers/(.*)\.rb$})          { 'test' }
  watch(%r{^test/test_helper\.rb$})           { 'test' }
  watch(%r{^lib/roro/(.+)\.rb$})              { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^lib/roro/cli/(.+)\.rb$})          { |m| "test/cli/#{m[1]}_test.rb" }
  watch(%r{^lib/roro/cli/(.+)\.yml$})         { |m| "test/cli" }
  watch(%r{^lib/roro/cli/(.+)\.tt$})          { |m| "test/cli" }
end
