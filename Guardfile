require 'pry'
require 'byebug'
Pry.config.input = STDIN
Pry.config.output = STDOUT

guard 'livereload' do
  extensions = {
    css: :css,
    scss: :css,
    sass: :css,
    js: :js,
    coffee: :js,
    html: :html,
    png: :png,
    gif: :gif,
    jpg: :jpg,
    jpeg: :jpeg
  }

  rails_view_exts = %w[erb haml slim]

  compiled_exts = extensions.values.uniq
  watch(%r{public/.+\.(#{compiled_exts * '|'})})

  extensions.each do |ext, type|
    watch(%r{
          (?:app|vendor)
          (?:/assets/\w+/(?<path>[^.]+) # path+base without extension
           (?<ext>\.#{ext})) # matching extension (must be first encountered)
          (?:\.\w+|$) # other extensions
          }x) do |m|
      path = m[1]
      "/assets/#{path}.#{type}"
    end
  end

  watch(%r{app/views/.+\.(#{rails_view_exts * '|'})$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{config/locales/.+\.yml})
end

minitest_options = {
  test_folders: ['test'],
  all_after_pass: false,
  all_on_start: false
}
guard :minitest, minitest_options do
  # ENV['DEBUGGERER'] = 'false'

  stack_tests = 'test/roro/stacks'
  watch(%r{^#{stack_tests}/(.*)/?(.*)_test\.rb$})

  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch(%r{^test/(.*)/?(.*)/shared_tests\.rb$}) { |m| "test/#{m[1]}" }

  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
  watch(%r{^test/helpers/(.*)\.rb$}) { ['test'] }

  watch('lib/roro/configurators/adventure_writer.rb') { 'test/roro/stacks/1/1/1/_test.rb' }
  watch('lib/roro/configurators/configurator.rb') { 'test/roro/stacks/1/1/1/_test.rb' }
end
