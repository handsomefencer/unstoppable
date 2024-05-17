# frozen_string_literal: true

require 'test_helper'

describe '3 postcss -> 1 MariaDB -> 2 ESBuild -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
