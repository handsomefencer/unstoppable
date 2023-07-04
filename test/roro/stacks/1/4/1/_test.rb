# frozen_string_literal: true

require_relative '../shared_test'

describe '1 -> 3 -> 1: database: sqlite, rails version: 6.1' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Invariant { assert_configuration_sqlite }

  describe 'must have correct rails' do
    Then { assert_file 'Gemfile', /gem ["']rails["'], ["']~> 6.1.7/ }
  end
end
