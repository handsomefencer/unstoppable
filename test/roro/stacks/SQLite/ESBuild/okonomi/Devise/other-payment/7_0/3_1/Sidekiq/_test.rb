# frozen_string_literal: true

require 'test_helper'

describe '4 SQLite -> 1 ESBuild -> 1 okonomi -> 1 Devise -> 2 other-payment -> 2 7_0 -> 1 3_1 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
