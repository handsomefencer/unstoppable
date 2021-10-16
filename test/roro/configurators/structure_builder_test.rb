# frozen_string_literal: true

require 'test_helper'

describe StructureBuilder do
  Given(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  Given(:structure)      { StructureBuilder.build }

  describe '#structure' do
    Then { assert structure.is_a?(Hash) }
  end
end
