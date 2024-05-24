# frozen_string_literal: true

require 'test_helper'

describe '5 none -> 4 SQLite -> 2 ESBuild -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
