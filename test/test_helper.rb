# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
ENV['RORO_ENV'] ||= 'test'

require 'byebug'
require 'fileutils'
require 'minitest/autorun'
require 'minitest/given'
require 'minitest/focus'
require 'minitest/hooks/default'
# require 'minitest/pride'
require 'minitest/spec'
require 'mocha/minitest'
require 'climate_control'
require 'roro'

Dir["#{Dir.pwd}/test/helpers/**/*.rb"].each { |f| require f }

include Roro::Configurators
include Roro::Crypto

# include Roro::Test::Helpers::Mocks
include Roro::Test::Helpers::FilesHelper
# include Roro::Test::Helpers::Stories
# include Roro::Test::Helpers::Stories::Rails
# include Roro::Test::Helpers::Stories::WorkBench
