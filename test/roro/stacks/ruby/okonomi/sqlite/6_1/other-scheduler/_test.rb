# frozen_string_literal: true

require 'test_helper'

describe '1 okonomi -> 3 postgres -> 2 7_0 -> 2 sidekiq' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
