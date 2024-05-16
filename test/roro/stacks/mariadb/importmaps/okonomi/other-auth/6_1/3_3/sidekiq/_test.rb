# frozen_string_literal: true

require 'test_helper'

describe '1 MariaDB -> 2 Importmaps -> 1 okonomi -> 2 other-auth -> 1 6_1 -> 3 3_3 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
