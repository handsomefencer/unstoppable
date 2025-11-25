# frozen_string_literal: true

require 'stack_test_helper'

describe '2 rails_7_2 -> 3 PostCSS -> 3 Postgres -> 4 Vite -> 2 ruby_3_4' do
  Given(:workbench) {}
  
  Given do
    # skip
    # debuggerer
  end
  # focus
  Then { assert_correct_manifest(__dir__) }
end
