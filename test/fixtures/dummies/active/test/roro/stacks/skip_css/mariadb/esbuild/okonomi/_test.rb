# frozen_string_literal: true

require 'stack_test_helper'

describe '5 skip_css -> 1 MariaDB -> 2 ESBuild -> 1 okonomi' do
  Given(:workbench) {}

  Given do

    debuggerer
  end

  Then { assert_correct_manifest(__dir__) }
end
