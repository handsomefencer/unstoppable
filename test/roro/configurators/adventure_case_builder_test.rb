# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:case_builder) { AdventureCaseBuilder.new }

  describe '#build_cases' do
    Given(:stack_root) { Roro::CLI.catalog_root}
    Given(:stack) {  }
    Given(:cases) { case_builder.build_cases(stack_root) }
    # Then { assert_equal 'blah', cases }
  end

  describe '#build_itineraries' do
    Given(:itineraries) { case_builder.build_itineraries(stack_path) }
    Given(:paths)   { [] }

    context 'when stack is a story must return empty' do
      When(:stack) { 'story' }
      Then { assert_empty itineraries }
    end

    context 'when stack is inflection' do
      When(:stack) { 'stacks' }
      Then { assert_empty itineraries }
    end

    context 'when stack has two inflections' do
      When(:stack) { 'stack/stack' }
      Then { assert_equal 4, itineraries.size }
    end

    context 'when has nested inflections' do
      When(:stack) { 'stack' }
      Then { assert_equal 12, itineraries.size }
    end
  end
end
