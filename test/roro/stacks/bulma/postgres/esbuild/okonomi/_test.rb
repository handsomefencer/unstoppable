# frozen_string_literal: true

require 'stack_test_helper'

describe '2 Bulma -> 3 Postgres -> 2 ESBuild -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    # debugger
  end

  Then { assert_correct_manifest(__dir__) }
end
