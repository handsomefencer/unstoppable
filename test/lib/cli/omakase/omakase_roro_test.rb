require "test_helper"

describe Roro::CLI do

  before { prepare_destination 'workbench' }
  Given(:cli) { Roro::CLI.new }
  Given(:generate) { cli.omakase_roro }

  Given { generate }

  Then { assert_directory './roro' }

  # Then
  # describe 'omakase' do
  #
  #   Given { cli.omakase }

  #   Then { assert_roro_directories }
  #   And  { assert_dockerfile }
  # end

  # describe 'omakase::rails' do
  #
  #   Given { cli.greenfield_rails }
  #
  #   # Then { assert_roro_directories }
  #   # And  { assert_dockerfile }
  # end
end