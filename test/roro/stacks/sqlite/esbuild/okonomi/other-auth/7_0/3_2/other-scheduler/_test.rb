# frozen_string_literal: true

require 'test_helper'

describe '4 SQLite -> 1 ESBuild -> 1 okonomi -> 2 other-auth -> 2 7_0 -> 2 3_2 -> 2 other-scheduler' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end