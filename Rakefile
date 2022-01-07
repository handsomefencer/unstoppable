require "bundler/gem_tasks"
require "rake/testtask"
require "json"
require "yaml"
require "roro"

Rake.add_rakelib 'rakelib/ci'
Rake.add_rakelib 'rakelib/ci/config'
Rake.add_rakelib 'rakelib/ci/matrices/run'
Rake.add_rakelib 'rakelib/ci/matrices/test_rollon'
Rake.add_rakelib 'rakelib/ci/matrices/test_rubies'
Rake.add_rakelib 'rakelib/ci/process'
Rake.add_rakelib 'rakelib/ci/workflows'
Rake.add_rakelib 'rakelib/ci/jobs'
Rake.add_rakelib 'rakelib/fixtures'
Rake.add_rakelib 'rakelib/fixtures/matrixes'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

