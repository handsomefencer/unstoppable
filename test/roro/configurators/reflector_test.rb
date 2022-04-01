# frozen_string_literal: true

require 'test_helper'

describe Reflector do
  Given(:stack_loc) { Roro::CLI.stacks }
  Given(:reflector) { Reflector.new(stack_loc) }

  describe '#reflect' do
    Given(:expected) {
      [
        unstoppable_developer_styles: [
          { okonomi: { languages: [
            {
              php: {
                adventures: [:laravel, :wordpress]
              },
              ruby: { frameworks: [
                { rails: { databases: [
                  { postgres: { versions: [:v13_5, :v14_1] } },
                  :sqlite
                ] } },
              :ruby_gem
            ] } }] } }]
      ]
      #   unstoppable_developer_styles: [
      #     { okonomi: {
      #       { languages: [
      #         {
      #           ruby: {
      #             frameworks: [
      #               { rails: {
      #                 databases: [
      #                   postgres: {
      #                     versions: %w[v13_5, v14_1]
      #                   },
      #                   'sqlite'
      #                 ]
      #               }},
      #               'ruby_gem'
      #             ]
      #           },
      #         ]
      #       },
      #       },
      #     }
      #   ]
      # ]
    }
    focus
    Then { assert_equal 'blah', reflector.reflect }
  end

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
    Then { assert_file 'mise/logs/itineraries.yml'}
  end

  describe '#cases()' do
    describe 'must return the expected' do
      describe 'number of cases' do
        Then { assert_equal 27, reflector.cases.size }
      end

      describe 'first case' do

        Then { assert_equal [1,1,1], reflector.cases[0] }
      end

      describe 'fifth case' do
        Then { assert_equal [1,2,1,2,1], reflector.cases[4] }
        Then  { assert_match /versions\/v3_10_1/, reflector.itineraries[4][1] }
        Then  { assert_match /databases\/postgres/, reflector.itineraries[4][0] }
      end
    end
  end

  describe '#itineraries()' do
    describe 'must return the expected' do
      describe 'number of itineraries' do
        Then { assert_equal 27, reflector.itineraries.size}
      end

      describe 'wordpress itinerary' do
        Then { assert_match /wordpress/, reflector.itineraries[1][0] }
      end

      describe 'django itinerary' do
        Then { assert_match /django/, reflector.itineraries[4][0]}
      end

      describe 'rails itinerary' do
        Then  { assert_match /databases\/postgres\/versions\/v13_5/, reflector.itineraries[8][0]}
        Then  { assert_match /rails\/versions\/v6_1/, reflector.itineraries[8][1]}
        Then  { assert_match /ruby\/versions\/v2_7/, reflector.itineraries[8][2]}

        Then  { assert_equal [1, 3, 1, 1, 1, 1, 1], reflector.cases[8]}
      end
    end
  end
end

