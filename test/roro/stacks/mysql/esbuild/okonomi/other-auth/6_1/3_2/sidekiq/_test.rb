# frozen_string_literal: true

require 'test_helper'

describe '2 MySQL -> 1 ESBuild -> 1 okonomi -> 2 other-auth -> 1 6_1 -> 2 3_2 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
