# frozen_string_literal: true

require 'test_helper'

describe '1 okonomi -> 1 mariadb -> 1 6_1 -> 1 none' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }
end
