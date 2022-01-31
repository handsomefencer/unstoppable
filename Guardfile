
guard :minitest, test_folders: ['test/roro', 'test/tasks', 'lib/roro/stacks'] do
  watch(%r{^lib/roro/stacks/(.*)\/?(.*)_test\.rb$})
  watch(%r{^lib/roro/stacks/(.*/)?([^/]+)\.yml$})      { |m| "lib/roro/stacks/#{m[1]}test" }
  watch(%r{^lib/roro/stacks/(.*/)?templates/(.*)$}) { |m| "lib/roro/stacks/#{m[1]}test" }

  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
  watch(%r{^test/helpers/(.*)\.rb$})      { ['test', 'lib/roro/stacks'] }
end
