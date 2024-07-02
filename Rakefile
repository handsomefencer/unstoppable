# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'json'
require 'yaml'
require 'roro'
require 'debug'

rakefiles = Dir.glob("#{Dir.pwd}/rakelib/**/*")
Rake.add_rakelib(*rakefiles)

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
                 .exclude('test/fixtures/dummies/**/*')
end

Rake::TestTask.new('test:ci') do |t|
  testfiles = ENV['TESTFILES'].split(",\n")
  # debugger
  # raise "$TESTFILES variable not set." unless testfiles
  t.libs << 'test'
  t.test_files = FileList[testfiles]
                 .exclude('test/fixtures/dummies/**/*')
end
Rake::TestTask.new('test:stacks') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/roro/stacks/**/*_test.rb']
end

Rake::TestTask.new('test:roro') do |t|
  files = %w[cli common configurators crypto].map {|f| "test/roro/#{f}/**/*_test.rb"}
  files << 'test/roro/roro_test.rb'

  t.libs << 'test'
  t.test_files = FileList[files]
end
