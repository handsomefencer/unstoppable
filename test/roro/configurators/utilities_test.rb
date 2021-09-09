# frozen_string_literal: true

require 'test_helper'

describe 'Configurators::Utilities' do
  let(:subject)      { Configurator }
  let(:options)      { nil }
  let(:config)       { subject.new(options) }
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
  let(:catalog)      { "#{catalog_root}/#{node}" }
  let(:execute)      { config.validate_catalog(catalog) }

  let(:config)  { Configurator.new }

  describe '#get_children(catalog)' do
    let(:execute) { config.get_children("#{catalog}") }
    let(:child)   { -> (child) { "#{catalog}/#{child}" } }

    context 'when directory has one file' do
      When(:node) { '/inflection/docker_compose'}

      Then { assert_equal execute.size, 1 }
    end

    context 'when directory has one folder' do
      When(:node) { '/inflection'}
      Then { assert_equal execute.size, 1 }
    end

    context 'when directory has several folders' do
      When(:node) { 'roro'}
      Then { assert_equal 4, execute.size }
    end
  end

  describe '#sanitize(hash)' do
    context 'when key is a string' do
      When(:options) { { 'key' => 'value' } }
      Then { assert config.sanitize(options).keys.first.is_a? Symbol }
    end

    context 'when value is a' do
      context 'string' do
        When(:options) { { 'key' => 'value' } }
        Then { assert config.sanitize(options).values.first.is_a? Symbol }
      end

      context 'array' do
        When(:options) { { 'key' => [] } }
        Then { assert config.sanitize(options).values.first.is_a? Array }
      end

      context 'array of hashes' do
        When(:options) { { 'key' => [{ 'foo' => 'bar' }] } }
        Then { assert_equal :bar, config.sanitize(options)[:key][0][:foo] }
      end
    end
  end

  describe '#sentence_from' do
    let(:call) { ->(array) { config.sentence_from(array) } }

    Then { assert_equal 'one, two and three', call[%w[one two three]] }
    And  { assert_equal 'one and two', call[%w[one two]] }
    And  { assert_equal 'one', call[%w[one]] }
  end
end
