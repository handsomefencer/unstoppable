# frozen_string_literal: true

require 'test_helper'

describe '1 MariaDB -> 1 ESBuild -> 1 okonomi -> 2 other-auth -> 3 7_1 -> 1 Vite -> 1 3_1 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
