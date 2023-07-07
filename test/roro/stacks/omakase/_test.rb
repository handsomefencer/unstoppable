# frozen_string_literal: true

require_relative '../shared_tests'

describe '2: unstoppable_rails_style: omakase' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then do
    assert_stacked_sqlite
  end
end
