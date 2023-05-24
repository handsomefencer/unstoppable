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
      Then { assert_equal 50, result.size }
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
      Then { assert_equal 50, result.size }
    end

    describe 'must return an itinerary in correct order' do
      Given(:expected) do
        [
          'unstoppable_developer_styles: okonomi', 'languages: ruby',
          'frameworks: rails', 'databases: postgres', 'versions: postgres_13_5',
          'schedulers: resque', 'versions: rails_6_1', 'versions: ruby_2_7'
        ]
      end
      Then { assert_equal expected, result[8] }
    end
  end

  describe '#adventure_structure' do
    Given(:result) { reflector.adventure_structure }

    describe 'must return a hash with nested :choices' do
      Then { assert_equal [1, 2, 3], result[:choices].keys }
      And { assert_equal 1, result[:choices].dig(1, 3, 2).keys.first }
    end

    describe 'must return a hash with nested :human' do
      Then do
        assert_includes result[:human]
          .dig('okonomi', 'ruby', 'rails',
               'postgres', 'postgres_13_5').keys, 'resque'
      end
    end
  end

  Given(:itinerary) { reflector.itineraries[8] }

  describe '#adventure_title()' do
    Given(:result) { reflector.adventure_title(itinerary) }
  end

  describe '#tech_tags' do
    Given(:result) { reflector.tech_tags(reflector.cases[8]) }
    Then { assert_includes result, 'alpine' }
  end
end
