require "test_helper"

describe '' do
  Given(:workbench)  { }
  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }

  describe 'must generate keys' do
    Then { assert_file 'mise/keys/base.key' }
  end
end

