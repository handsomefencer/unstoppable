require "bundler/gem_tasks"
require "rake/testtask"
require "json"
require "yaml"
require "roro"

Rake.add_rakelib 'rakelib/circleci'
Rake.add_rakelib 'rakelib/circleci/config'
Rake.add_rakelib 'rakelib/circleci/matrices/run'
Rake.add_rakelib 'rakelib/circleci/process'
Rake.add_rakelib 'rakelib/circleci/jobs'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

