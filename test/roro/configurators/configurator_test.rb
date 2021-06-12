# frozen_string_literal: true

require 'test_helper'

describe Configurator do

  let(:subject) { Configurator }
  let(:options) { nil }
  let(:config)  { subject.new(options) }

  describe '#sanitize(options' do
    context 'when key is a string' do
      When(:options) { { 'key' => 'value' } }
      Then { assert config.options.keys.first.is_a? Symbol }
    end

    context 'when value is a' do
      context 'string' do
        When(:options) { { 'key' => 'value' } }
        Then { assert config.options.values.first.is_a? Symbol }
      end

      context 'when value is an array' do
        When(:options) { { 'key' => [] } }
        Then { assert config.options.values.first.is_a? Array }
      end

      context 'when value is an array of hashes' do
        When(:options) { { 'key' => [{ 'foo' => 'bar' }] } }
        Then { assert_equal :bar, config.options[:key][0][:foo] }
      end
    end
  end

  describe '#structure' do
    Then { assert_includes config.structure.keys, :intentions }
    And  { assert_includes config.structure.keys, :choices }
    And  { assert_includes config.structure.keys, :env_vars }
  end


end
