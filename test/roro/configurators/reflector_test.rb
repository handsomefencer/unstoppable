# frozen_string_literal: true

require 'test_helper'

describe Reflector do
  Given(:stack_loc) { Roro::CLI.stacks }
  Given(:reflector) { Roro::Configurators::Reflector.new }

  describe '#reflection()' do
    Then { assert_includes reflector.reflection.keys, :inflections }
    And  { assert_includes reflector.reflection.keys, :stories }
    And  { assert_includes reflector.reflection.keys, :picks }
    And  { assert_includes reflector.reflection.keys, :stacks }
  end

  describe '#log_to_mise' do
    Given { reflector.log_to_mise('cases', reflector.cases) }
    Given { reflector.log_to_mise('itineraries', reflector.itineraries) }
    Given { reflector.log_to_mise('reflector', reflector.reflection) }
    Then { assert_file 'mise/logs/itineraries.yml' }
  end

  describe '#cases()' do
    Given(:result) { reflector.cases }

    describe 'must return an array with' do
      describe 'the correct number of cases' do
        Then { assert_equal 38, result.size }
      end

      describe 'the expected cases' do
        Given(:expected) do
          [
            '1 1 1',           '1 1 2',           '1 2 1 1 1',
            '1 2 1 1 2',       '1 2 1 2 1',       '1 2 1 2 2',
            '1 2 2 1',         '1 2 2 2',         '1 3 1 1 1 1 1 1',
            '1 3 1 1 1 1 1 2', '1 3 1 1 1 1 2 1', '1 3 1 1 1 1 2 2',
            '1 3 1 1 1 2 1 1', '1 3 1 1 1 2 1 2', '1 3 1 1 1 2 2 1',
            '1 3 1 1 1 2 2 2', '1 3 1 1 2 1 1 1', '1 3 1 1 2 1 1 2',
            '1 3 1 1 2 1 2 1', '1 3 1 1 2 1 2 2', '1 3 1 1 2 2 1 1',
            '1 3 1 1 2 2 1 2', '1 3 1 1 2 2 2 1', '1 3 1 1 2 2 2 2',
            '1 3 1 2 1 1 1',   '1 3 1 2 2 1 1',   '1 3 1 2 1 1 2',
            '1 3 1 2 2 1 2',   '1 3 1 2 1 2 1',   '1 3 1 2 1 2 2',
            '1 3 1 2 2 2 1',   '1 3 1 2 2 2 2',   '1 3 2 1',
            '1 3 2 2', '2 1',   '2 2', '3 1',     '3 2'
          ].map { |i| i.split(' ').map(&:to_i) }
        end

        Then { expected.each { |e| assert_includes result, e } }
      end
    end
  end

  describe '#itineraries()' do
    Given(:result) { reflector.itineraries }

    describe 'must return the expected' do
      describe 'number of itineraries' do
        focus
        Then { assert_equal 38, result.size }
      end

      describe 'first itinerary' do
        focus
        Then { assert_equal 38, result[8] }
      end
      focus

      describe 'wordpress itinerary' do
        # Then { assert_match(/wordpress/, reflector.itineraries[1][0]) }
      end

      describe 'django itinerary' do
        # Then { assert_match(/django/, reflector.itineraries[4][0]) }
      end

      describe 'rails itinerary' do
        # Then  { assert_match(%r{databases/postgres/versions/v13_5}, reflector.itineraries[8][0]) }
        # Then  { assert_match(%r{rails/versions/v6_1}, reflector.itineraries[8][1]) }
        # Then  { assert_match(%r{ruby/versions/v2_7}, reflector.itineraries[8][2]) }
      end
    end
  end
end
