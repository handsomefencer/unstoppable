# frozen_string_literal: true

require 'test_helper'

describe '3 Postgres -> 1 Bun -> 1 okonomi' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
