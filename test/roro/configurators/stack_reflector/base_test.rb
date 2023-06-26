# frozen_string_literal: true

require 'test_helper'

describe Roro::Configurators::StackReflector do
  Given { use_fixture_stack('alpha') }

  Given(:subject) { Roro::Configurators::StackReflector.new }

  describe '#initialize' do
    Then do
      assert subject.adventures
      assert subject.cases
      assert subject.reflection
      assert subject.stack
    end

    And do
      keys = subject.reflection.keys
      assert_includes keys, :adventures
      assert_includes keys, :cases
      assert_includes keys, :itineraries
      assert_includes keys, :stack
      assert_includes keys, :structure
    end
  end

  describe '#cases' do
    Given(:result) { subject.cases }
    Given(:expected_cases) { expected_adventure_cases }

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

  describe '#adventures' do
    Given(:expected) { expected_adventure_cases }
    Given(:result) { subject.adventures }

    describe 'must return a Hash' do
      Then { assert_equal Hash, result.class }
    end

    describe 'must return the correct number of adventures' do
      Then { assert_equal expected_adventure_cases.size, result.size }
    end
  end

  describe '#adventure_structure' do
    describe 'must return a hash with nested hash under :choices' do
      Given(:choices) { subject.structure.dig(:choices) }
      Then { assert_equal([1, 2, 3], choices.keys) }
      And { assert_equal({}, choices.dig(1, 3, 2, 1)) }
    end

    describe 'must return a hash with nested hash under :human' do
      Given(:human) { subject.structure.dig(:human) }
      Then { assert_equal(%w[okonomi omakase sashimi], human.keys) }
      And { assert_equal({}, human.dig('okonomi', 'php', 'laravel')) }
    end
  end
end
