# frozen_string_literal: true

require 'test_helper'

describe StructureBuilder do
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:builder)      { StructureBuilder.new }

  describe '#structure' do
    Then { assert builder.structure.is_a?(Hash) }
  end
end
