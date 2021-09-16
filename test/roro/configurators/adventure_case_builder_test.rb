# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:case_builder)      { AdventureCaseBuilder.new }

  describe '#build_cases' do
    let(:catalog) { 'roro' }
    let(:cases) { case_builder.build_cases(catalog_path) }
    # Given { stubs_answer('1') }
    Then  { assert_equal 'blah', cases}


  end
end
