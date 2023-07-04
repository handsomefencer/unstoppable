# frozen_string_literal: true

require_relative '../shared_test'

describe '1 -> 2 -> 1: ' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Invariant { assert_configuration_mysql }

  describe 'must have correct rails' do
    Then { assert_file('Gemfile', /gem ["']rails["'], ["']~> 6.1.7/) }
  end
end
