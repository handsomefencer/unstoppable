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

    describe 'must return the correct number of cases' do
      Then { assert_equal 38, result.size }
    end

    describe 'must return the expected cases' do
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

  describe '#itineraries()' do
    Given(:result) { reflector.itineraries }

    describe 'must return the expected number of itineraries' do
      Then { assert_equal 38, result.size }
    end
  end

  describe '#adventure_structure' do
    describe 'must return a hash with nested :choices' do
      Given(:choices) { reflector.adventure_structure[:choices] }
      Then { assert_equal [1, 2, 3], choices.keys }
      And { assert_equal 1, choices.dig(1, 3, 2).keys.first }
    end

    describe 'must return a hash with nested :human' do
      Given(:human) { reflector.adventure_structure[:human] }
      Then { assert_equal %w[okonomi omakase sashimi], human.keys }
      And { assert_equal %w[php python ruby], human.dig('okonomi').keys }
      And { assert_includes human.dig('okonomi', 'ruby').keys, 'rails' }
    end
  end

  Given(:itinerary) { reflector.itineraries[8] }

  describe '#adventure_title()' do
    Given(:result) { reflector.adventure_title(itinerary) }
    # focus
    Then { assert_equal 'blah', result }
    # byebug
    # inflections.each
  end

  describe '#tech_tags' do
    Given(:result) { reflector.tech_tags(reflector.cases[8]) }
    focus
    Then { assert_equal 'blah', result }
  end
end
