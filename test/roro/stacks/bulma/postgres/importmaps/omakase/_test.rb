# frozen_string_literal: true

require 'test_helper'

describe '2 Bulma -> 3 Postgres -> 3 Importmaps -> 2 omakase' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
