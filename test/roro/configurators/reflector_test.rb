# frozen_string_literal: true

require 'test_helper'

describe Reflector do
  Given(:stack_loc)       { Roro::CLI.stacks }
  Given(:reflector)    { Reflector.new(stack_loc) }

  describe '#reflection()' do
    Then { assert_includes reflector.reflection.keys, :inflections }
    And  { assert_includes reflector.reflection.keys, :stories }
    And  { assert_includes reflector.reflection.keys, :picks }
    And  { assert_includes reflector.reflection.keys, :stacks }
  end

  describe '#cases()' do
    describe 'must return the expected' do
      describe 'number of cases' do
        Then { assert_equal 26, reflector.cases.size }
      end

      describe 'first case' do
        Then { assert_equal [1,1,1], reflector.cases[0] }
      end

      describe 'fifth case' do
        Then { assert_equal [1,2,1,2,1], reflector.cases[5] }
      end
    end
  end

  describe '#itineraries()' do
    describe 'must return the expected' do
      describe 'number of itineraries' do
        Then { assert_equal 26, reflector.itineraries.size}
      end

      describe 'wordpress itinerary' do
        Then { assert_match /wordpress/, reflector.itineraries[0][0] }
      end

      describe 'django itinerary' do
        Then { assert_match /django/, reflector.itineraries[5][0]}
      end

      describe 'rails itinerary' do
        Then  { assert_match /databases\/postgres/, reflector.itineraries[5][0]}
      end
    end
  end
end

