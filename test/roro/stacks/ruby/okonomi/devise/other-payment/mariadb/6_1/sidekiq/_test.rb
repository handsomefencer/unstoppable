# frozen_string_literal: true

require 'test_helper'

describe '2 ruby -> 1 okonomi -> 1 devise -> 1 other-payment -> 1 mariadb -> 1 6_1 -> 2 sidekiq' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end
  focus
  Then { assert_correct_manifest(__dir__) }
end
