# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 -> 3 -> 2: ' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Invariant { assert_stacked_postgres }

  describe 'Gemfile with the correct' do
    describe 'rails version' do
      Then { assert_file 'Gemfile', /gem ["']rails["'], ["']~> 7.0.6/ }
    end
  end
end
