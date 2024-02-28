# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'json'
require 'yaml'
require 'roro'

Rake.add_rakelib 'rakelib/ci'
Rake.add_rakelib 'rakelib/ci/config'
Rake.add_rakelib 'rakelib/ci/matrices/run'
Rake.add_rakelib 'rakelib/ci/matrices/test_rollon'
Rake.add_rakelib 'rakelib/ci/matrices/test_rubies'
Rake.add_rakelib 'rakelib/ci/prepare/config'
Rake.add_rakelib 'rakelib/ci/prepare/workflows'
Rake.add_rakelib 'rakelib/ci/prepare'
Rake.add_rakelib 'rakelib/ci/test'
Rake.add_rakelib 'rakelib/ci/jobs'
Rake.add_rakelib 'rakelib/test'
Rake.add_rakelib 'rakelib/fixtures'
Rake.add_rakelib 'rakelib/fixtures/matrixes'
Rake.add_rakelib 'rakelib/docker/image'
Rake.add_rakelib 'rakelib/club'
Rake.add_rakelib 'rakelib/club/harvest'

Rake::TestTask.new('test') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
                 .exclude('test/fixtures/dummies/**/*')
end

Rake::TestTask.new('test:stories') do |t|
  t.libs << 'test'
  t.test_files = FileList['test/roro/stacks/**/*_test.rb']
end
