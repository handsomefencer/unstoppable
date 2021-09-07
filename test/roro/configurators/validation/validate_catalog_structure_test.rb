# # frozen_string_literal: true

require 'test_helper'

describe 'validate catalog structure' do
  let(:subject)      { Configurator }
  let(:options)      { nil }
  let(:config)       { subject.new(options) }
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog)      { "#{catalog_root}/#{node}" }
  let(:execute)      { config.validate_catalog(catalog) }

  describe 'valid'do
    let(:assert_valid_catalog) do
      lambda { |node|
        catalog = "#{catalog_root}/#{node}"
        execute = config.validate_catalog(catalog)
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

  describe '#get_children(catalog)' do
#   #   before { skip }
#   #   let(:folder)  { "valid" }
#   #   let(:execute) { config.get_children("#{catalog}") }
#   #   let(:child)   { -> (child) { "#{catalog}/#{child}" } }
#   #
    context 'when directory has one file' do
#   #     let(:folder) { 'valid/roro/docker_compose'}
#   #
#   #     Then { assert_equal execute, [child['docker-compose.yml']] }
#   #     And  { assert_equal execute.size, 1 }
#   #   end
#   #
#   #   context 'when directory has one folder' do
#   #     let(:folder) { 'valid/roro/docker_compose'}
#   #
#   #     Then { assert_equal execute, [child['docker-compose.yml']] }
#   #     And  { assert_equal execute.size, 1 }
#   #   end
#   #
#   #   context 'when directory has several folder' do
#   #     context 'and a hidden file mustreturn one child' do
#   #       let(:folder) { 'valid/roro'}
#   #
#   #       Then { assert_includes execute, child['k8s'] }
#   #     end
    end
  end
end