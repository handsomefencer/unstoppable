$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "roro"
require "minitest/autorun"
require "minitest/spec"
require "minitest/given"
require "thor_helper"

require "generators/shared_expectations"

# include Roro::Test::SharedExpectations
include TestHelper::Files::Assertions
Minitest.after_run do
  FileUtils.rm_rf 'tmp/greenfield' if File.exist? 'tmp/greenfield'
  FileUtils.rm_rf 'tmp/dummy' if File.exist? 'tmp/dummy'
  FileUtils.mkdir_p 'tmp/greenfield'
  FileUtils.mkdir_p 'tmp/dummy'
  gem_root = Gem::Specification.find_by_name('roro').gem_dir
  Dir.chdir File.join(gem_root, 'tmp')
  
  # FileUtils.copy_entry 'test/dummy', 'tmp/dummy'

end
