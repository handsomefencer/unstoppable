# frozen_string_literal: true

require 'test_helper'

describe '3 Postgres -> 2 Vite -> 1 okonomi -> 2 other-auth -> 1 6_1 -> 1 3_1 -> 1 Sidekiq' do
  Given(:workbench) {}
  
  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
