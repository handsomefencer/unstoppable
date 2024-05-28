# frozen_string_literal: true

require 'stack_test_helper'

describe '1 Bootstrap -> 3 Postgres -> 2 ESBuild -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
