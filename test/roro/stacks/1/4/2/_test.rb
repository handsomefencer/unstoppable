# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 -> 4 -> 2' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Invariant { assert_correct_configuration_sqlite }

  describe 'Gemfile with the correct rails version' do
    Then { assert_file 'Gemfile', /gem ["']rails["'], ["']~> 7.0.6/ }
  end
end
