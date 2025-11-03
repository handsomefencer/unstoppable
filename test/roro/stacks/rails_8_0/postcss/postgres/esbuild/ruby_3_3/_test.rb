# frozen_string_literal: true

require 'stack_test_helper'

describe '3 rails_8_0 -> 3 PostCSS -> 3 Postgres -> 2 ESBuild -> 1 ruby_3_3' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
