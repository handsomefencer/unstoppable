# frozen_string_literal: true

require_relative '../shared_tests'

describe '2 ruby -> 2 omakase' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end
end
