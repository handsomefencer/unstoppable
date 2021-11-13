require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

Rake::TestTask.new(:test_stacks) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["lib/roro/stacks/**/*_test.rb"]
end

task :default => :test
