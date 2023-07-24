# frozen_string_literal: true

require 'test_helper'

describe '2 ruby -> 1 okonomi -> 3 postgres -> 2 7_0 -> 2 other-auth -> 2 vite -> 2 stripe -> 1 other-scheduler' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
