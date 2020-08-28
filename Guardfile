options = {
  cli: '-f',
  all_on_start: true,
  all_after_pass: true
}

guard :minitest, options do

  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^lib/roro/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^test/thor_helper\.rb$})      { 'test' }
  watch(%r{^lib/roro/cli/(.+)\.rb$}) { |m| "test/cli/#{m[1]}_test.rb" }
  watch(%r{^lib/roro/cli/templates/base(.+)\.yml$}) { |m| "test/cli" }
  watch(%r{^lib/roro/cli/templates/rollon(.+)\.yml$}) { |m| "test/cli/rollon" }
  watch(%r{^lib/roro/cli/templates/greenfield(.+)\.yml$}) { |m| "test/cli/greenfield" }
end
