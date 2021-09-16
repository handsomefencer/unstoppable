# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:case_builder)      { AdventureCaseBuilder.new }

  let(:cases) { case_builder.build_cases(catalog_path) }
  let(:catalog) { 'roro' }

  describe '#build_itineraries' do
    let(:itineraries) { case_builder.build_itineraries(cases) }
    Then { assert_equal 'blah', itineraries }
  end

  describe '#build_cases' do
    context 'first inflection' do
      Then { assert_equal 'blah', cases }
      # Then { assert_includes cases.keys, 'node'}
      # And  { assert_includes cases.keys, 'php'}
      # And  { assert_includes cases.keys, 'ruby'}
      # And  { assert_includes cases.keys, 'python' }
    end

    context 'second inflection' do
      # Then { assert_includes cases['python'].keys, 'django' }
      # And  { assert_includes cases['python'].keys, 'flask' }
      # And  { assert_includes cases['ruby'].keys, 'rails' }
      # And  { assert_includes cases['ruby'].keys, 'ruby_gem' }
      # And  { assert_includes cases['ruby']['rails'].keys, 'ruby_gem' }
    end
  end
end
