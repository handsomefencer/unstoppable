require 'test_helper'

describe 'adventure::wordpress::0 ' do
  Given(:workbench)  { }
  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }

  describe 'must have correct variables in files' do
    Then  { assert_file 'mise/env/base.env', /WORDPRESS_IMAGE=wordpress/ }
  end
end
