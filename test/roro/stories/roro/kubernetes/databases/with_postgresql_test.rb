# require 'test_helper'
#
# describe Roro::CLI do
#   before { skip }
#   Given { rollon_rails_test_base }
#
#   Given(:cli)       { Roro::CLI.new }
#   Given(:rollon)    { cli.rollon }
#
#   describe '.rollon with postgresql' do
#
#     Given { rollon }
#
#     describe 'pg gem in gemfile' do
#
#       Given(:file)      { 'Gemfile' }
#       Given(:insertion) { "gem 'pg'" }
#
#       Then { assert_insertion }
#     end
#   end
# end
