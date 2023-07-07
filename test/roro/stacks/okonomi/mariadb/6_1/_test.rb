# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 -> 1 -> 1: database: mariadb, rails version: 6.1' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Invariant { assert_stacked_mariadb }

  describe 'must have correct rails' do
    Then { assert_file('Gemfile', /gem ["']rails["'], ["']~> 6.1.7/) }
  end
end
