# # frozen_string_literal: true

require 'test_helper'

describe 'validate catalog structure' do
  let(:subject)      { Validator }
  let(:validator)    { subject.new }
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog)      { "#{catalog_root}/#{node}" }
  let(:execute)      { validator.validate_catalog(catalog) }

  describe 'valid'do
    let(:assert_valid_catalog) do
      lambda { |node|
        catalog = "#{catalog_root}/#{node}"
        execute = validator.validate_catalog(catalog)
        assert_nil execute
      }
    end

    context 'template' do
      Then { assert_valid_catalog['templates'] }
    end

    context 'inflection' do
      Then { assert_valid_catalog['inflection'] }
    end

    context 'roro' do
      Then { assert_valid_catalog['roro'] }
    end
  end

  describe 'invalid' do
    let(:error) { Roro::Error }

    context 'empty' do
      let(:error_message) { 'Catalog cannot be an empty folder' }

      When(:node) { 'empty' }
      Then { assert_correct_error }
    end
  end
end
