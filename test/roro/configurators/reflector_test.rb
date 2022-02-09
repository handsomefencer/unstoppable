# frozen_string_literal: true

require 'test_helper'

describe Reflector do
  Given(:stack_loc)       { Roro::CLI.stacks }
  Given(:reflector)    { Reflector.new(stack_loc) }


  describe '#reflection()' do
    Then { assert_includes reflector.reflection.keys, :inflections }
  end

  describe '#cases()' do
    describe 'must return the expected number of cases' do
      Then { assert_equal 26, reflector.cases.size }
    end
  end

  describe '#itineraries()' do
    describe 'must return the expected number of itineraries' do
      Then { assert_equal 26, reflector.itineraries.size}
    end
  end

  describe 'wordpress' do
    # And  { assert_equal [1,1,1], reflector.cases.first }
    And  { assert_match /wordpress/, reflector.itineraries[0][0] }

  end

end

