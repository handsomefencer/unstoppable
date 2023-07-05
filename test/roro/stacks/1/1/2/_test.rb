# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 -> 1 -> 2: database: mariadb, rails version: 7.0' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Invariant { assert_stacked_mariadb }

  describe 'must have correct rails version' do
    Then { assert_file('Gemfile', /gem ["']rails["'], ["']~> 7.0.6/) }
  end
end
