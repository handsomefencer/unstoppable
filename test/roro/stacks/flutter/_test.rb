# frozen_string_literal: true

require 'test_helper'

describe '1 flutter' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
