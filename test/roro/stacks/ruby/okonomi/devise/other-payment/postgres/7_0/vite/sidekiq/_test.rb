# frozen_string_literal: true

require 'test_helper'

describe '2 ruby -> 1 okonomi -> 1 devise -> 1 other-payment -> 3 postgres -> 2 7_0 -> 2 vite -> 2 sidekiq' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
