# frozen_string_literal: true

require_relative '../shared_test'

describe '1 -> 2 -> 2: database: postgres, rails version: 7.0' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Invariant { assert_configuration_postgres }

  describe 'Gemfile with the correct' do
    describe 'rails version' do
      Then { assert_file 'Gemfile', /gem ["']rails["'], ["']~> 7.0.5/ }
    end
  end
end
