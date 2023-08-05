# frozen_string_literal: true

require 'test_helper'

describe '2 ruby -> 1 okonomi -> 2 other-auth -> 3 postgres -> 2 7_0 -> 2 vite -> 1 other-scheduler' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end
  focus
  Then do

    assert_file 'mise/containers/builder/Dockerfile'
    assert_correct_manifest(__dir__) 
  end
end
