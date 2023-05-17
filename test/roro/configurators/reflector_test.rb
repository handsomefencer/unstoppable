# frozen_string_literal: true

require 'test_helper'
require 'roro/configurators/reflector'

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

  describe '#adventure_cases()' do
    Given(:expected) do
      [
        '1 1 1',
        '1 1 2',
        '1 2 1 1 1',
        '1 2 1 1 2',
        '1 2 1 2 1',
        '1 2 1 2 2',
        '1 2 2 1',
        '1 2 2 2',
        '1 3 1 1 1 1 1 1',
        '1 3 1 1 1 1 1 2',
        '1 3 1 1 1 1 2 1',
        '1 3 1 1 1 1 2 2',
        '1 3 1 1 1 2 1 1',
        '1 3 1 1 1 2 1 2',
        '1 3 1 1 1 2 2 1',
        '1 3 1 1 1 2 2 2',
        '1 3 1 1 2 1 1 1',
        '1 3 1 1 2 1 1 2',
        '1 3 1 2 1 1 1',
        '1 3 1 2 1 1 2',
        '1 3 1 2 1 2 1',
        '1 3 1 2 1 2 2',
        '1 3 2 1',
        '1 3 2 2',
        '2 1',
        '2 2',
        '3 1',
        '3 2'
      ].map { |item| item.split(' ').map(&:to_i) } # & :to_i # .join('\\n') }
    end

    Given(:unexpected) do
      [
        # [1, 2, 1, 1],
        # [1, 2, 1, 2],
        # [1, 3, 1, 1, 2, 1, 2, 1],
        # [1, 3, 1, 1, 2, 1, 2, 2],
        # [1, 3, 1, 1, 2, 2, 1, 1],
        #  [1, 3, 1, 1, 2, 2, 1, 2],
        #  [1, 3, 1, 1, 2, 2, 2, 1],
        #  [ 1, 3, 1, 1, 2, 2, 2, 2],
        #  [1, 3, 1, 2, 2, 1, 1],
        #  [1, 3, 1, 2, 2, 1, 2],
        #  [1, 3, 1, 2, 2, 2, 1],
        #  [1, 3, 1, 2, 2, 2, 2],
        #  [1, 3, 1, 1, 1, 1, 1],
        #  [1, 3, 1, 1, 1, 1, 2],
        #  [1, 3, 1, 1, 1, 2, 1],
        #  [1, 3, 1, 1, 1, 2, 2],
        #  [1, 3, 1, 1, 2, 1, 1],
        #  [1, 3, 1, 1, 2, 1, 2],
        #  [1, 3, 1, 1, 2, 2, 1],
        #  [1, 3, 1, 1, 2, 2, 2],
        #  [1, 3, 1, 1],
        #  [1, 3, 1, 2],
        [3]
      ]
    end

    describe 'must return the expected' do
      Given(:result) { reflector.adventure_cases }
      describe 'number of cases' do
        focus
        Then do
          # assert_equal expected.size, result.size
          # assert_equal 'blah', (result - expected)
          expected.each do |e|
            assert_includes result, e
          end

          unexpected.each do |e|
            refute_includes result, e
          end
        end
      end
      describe '' do
        # Then do
        #   # assert_equal 26, result.count
        #   assert_equal [1, 1, 1], result[20]
        # end
      end

      describe 'first case' do
        # Given { skip }
        # Then do
        #   expected.each do |item|
        #     assert_includes reflector.adventure_cases, item
        #   end
        # end
      end
    end
  end

  describe '#cases()' do
    describe 'must return the expected' do
      describe 'first case' do
        Then { assert_equal [1, 1, 1], reflector.cases[0] }
      end

      describe 'fifth case' do
        Then do
          # binding.pry
          assert_equal [1, 2, 1, 2, 1], reflector.cases[4]
        end
        And  { assert_match(%r{versions/v3_10_1}, reflector.itineraries[4][1]) }
        And  { assert_match(%r{databases/postgres}, reflector.itineraries[4][0]) }
      end

      describe 'cases' do
      end
    end
  end

  describe '#itineraries()' do
    describe 'must return the expected' do
      describe 'number of itineraries' do
        Then { assert_equal 27, reflector.itineraries.size }
      end

      describe 'wordpress itinerary' do
        Then { assert_match(/wordpress/, reflector.itineraries[1][0]) }
      end

      describe 'django itinerary' do
        Then { assert_match(/django/, reflector.itineraries[4][0]) }
      end

      describe 'rails itinerary' do
        Then  { assert_match(%r{databases/postgres/versions/v13_5}, reflector.itineraries[8][0]) }
        Then  { assert_match(%r{rails/versions/v6_1}, reflector.itineraries[8][1]) }
        Then  { assert_match(%r{ruby/versions/v2_7}, reflector.itineraries[8][2]) }
      end
    end
  end
end
