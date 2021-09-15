# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:case_builder)      { AdventureCaseBuilder.new }

  describe '#build_cases' do
    let(:catalog) { 'roro' }
    # Given { stubs_answer('1') }
    Given { case_builder.build(catalog_path) }
    Then  { assert_equal Hash, case_builder.cases.class }
    And   { assert_equal 'roro', case_builder.cases.keys.first }
    And   { assert_includes case_builder.cases['roro'].keys, 'ruby' }
    And   { assert_includes case_builder.cases['roro']['ruby'].keys, 'blah' }
    # And   { assert_includes case_builder.cases['roro'].keys, :stories }
    # And   { assert_includes 'k8s', case_builder.cases }
    # And   { assert_equal 'blah', case_builder.cases.first.keys }


  end
end
