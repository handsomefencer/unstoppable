require "test_helper"

describe Roro::CLI do

  before { prepare_destination 'crypto' }
  Given(:cli) { Roro::CLI.new }
  Given(:generate) { cli.omakase_roro}
  Invariant { assert_roro_generated }

  Given { generate }

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