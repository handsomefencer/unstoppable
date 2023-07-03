# frozen_string_literal: true

require_relative '../shared_test'

describe '1 -> 1 -> 1: database: postgres, rails version: 6.1' do
  Given(:workbench) {}

  Given do
    skip
    debuggerer
    rollon(__dir__)
  end

  Invariant { assert_1_1_tests }

  describe 'must have correct rails' do
    Then { assert_file('Gemfile', /gem ["']rails["'], ["']~> 6.1.7/) }
  end
end
