# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::Reflector do
  Given { use_fixture_stack('complex') }
  Given(:subject) { Roro::Configurators::Reflector.new }

  describe '#initialize' do
    Then { assert subject.stack }
    And { assert subject.stack_reflection }
  end

  describe '#reflect' do
    Given(:stack_reflection) { subject.stack_reflection }
    describe 'must set correct cases' do
      Then { assert_match 'complex', stack_reflection.dig(:stack) }
    end

    describe 'must return a hash with keys matching picks' do
    end
    # Given { subject.reflect }
    # focus
    # Then { assert_equal 'blah', subject.adventures[0][:picks] }
    # Then { assert_equal 'blah', subject.adventures.dig(0, :picks) }
    Then do
      expected_adventure_cases.each_with_index do |expected, index|
        assert_equal expected, subject.reflect.keys[index], msg: "index: #{index}"
      end
    end
  end

  describe '#cases()' do
    Given(:result) { subject.cases }
    Given(:expected_cases) do
      expected_adventure_cases.map { |e| e.split(' ').map(&:to_i) }
    end

    describe 'must return the correct number of cases' do
      Then { assert_equal 38, result.size }
    end

    describe 'must return the expected cases' do
      Then { expected_cases.each { |e| assert_includes result, e } }
    end

    describe 'must return the correct order of cases' do
      Then { assert_equal(expected_cases, result) }
    end
  end

  describe '#reflection()' do
    Given { skip }
    (Then { assert_includes subject.reflection.keys, :inflections })
    And  { assert_includes subject.reflection.keys, :stories }
    And  { assert_includes subject.reflection.keys, :picks }
    And  { assert_includes subject.reflection.keys, :stacks }
  end

  describe '#log_to_mise' do
    Given { subject.log_to_mise('cases', subject.cases) }
    Given { subject.log_to_mise('itineraries', subject.itineraries) }
    Given { subject.log_to_mise('subject', subject.reflection) }
    Then { assert_file 'mise/logs/itineraries.yml' }
  end

  describe '#adventures()' do
    Given { skip }
    Given(:result) { subject.adventures }
    Given(:base_chapters) do
      ['alpine.yml', 'databases.yml', 'docker.yml', 'git.yml', 'redis.yml']
    end

    describe 'must return the correct number of adventures' do
      Then { assert_equal 38, result.size }
    end

    describe 'must return the expected chapters for each adventure' do
      describe 'okonomi php laravel' do
        Given(:expected) do
          base_chapters + ['okonomi.yml', 'php.yml', '_builder.yml',
                           'laravel.yml']
        end
        Then { assert_equal(expected, result[0].map { |f| f.split('/').last }) }
      end
    end

    describe 'okonomi ruby rails pg' do
      Given(:expected) do
        base_chapters + ['okonomi.yml', 'ruby.yml', '_builder.yml',
                         'databases.yml', 'rails.yml', 'postgres.yml',
                         'postgres_14_1.yml', 'ruby_3_0.yml',
                         'sidekiq.yml', 'rails_7_0.yml']
      end
      Given { skip }
      Then { assert_equal(expected, result[23].map { |f| f.split('/').last }) }
    end

    describe 'sashimi rails' do
      Given(:expected) { base_chapters + ['sashimi.yml', 'rails.yml'] }
      Then { assert_equal(expected, result[-1].map { |f| f.split('/').last }) }
    end
  end

  describe '#itineraries()' do
    Given(:result) { subject.itineraries }

    describe 'must return the expected number of itineraries' do
      Then { assert_equal 38, result.size }
    end
  end

  describe '#adventure_structure' do
    Given(:result) { subject.adventure_structure }

    describe 'must return a hash with nested :choices' do
      Then { assert_equal [1, 2, 3], result[:choices].keys }
      And { assert_equal 1, result[:choices].dig(1, 3, 2).keys.first }
    end

    describe 'must return a hash with nested :human' do
      Then { assert_equal %w[okonomi omakase sashimi], result[:human].keys }
    end
  end

  Given(:itinerary) { subject.itineraries[8] }

  describe '#adventure_title()' do
    Given(:result) { subject.adventure_title(itinerary) }
  end

  describe '#tech_tags' do
    Given(:result) { subject.tech_tags(subject.cases[8]) }
    Then { assert_includes result, 'alpine' }
  end
end
