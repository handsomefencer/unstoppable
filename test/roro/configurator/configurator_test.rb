require 'test_helper'

describe Roro::Configurator::Configurator do
  let(:subject) { Roro::Configurator::Configurator }
  let(:options) { nil }
  let(:config) { subject.new(options) }

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

  #   describe 'sanitizing when options contain' do
  #
  #
  #     describe 'nested hashes' do
  #
  #       Given(:options) { { story: :rails } }
  #
  #       Then { assert_equal expected, actual }
  #     end
  #
  #     describe 'nil' do
  #
  #       Given(:expected) { {} }
  #       Given(:options) { nil }
  #
  #       Then { assert_equal expected, actual }
  #     end
  #
  #     describe 'symbols' do
  #
  #       Given(:options) { { story: :rails } }
  #
  #       Then { assert_equal expected, actual }
  #     end
  #
  #     describe 'strings' do
  #
  #       Given(:options) { { 'story' =>  'rails' } }
  #
  #       Then { assert_equal expected, actual }
  #     end
  #
  #     describe 'booleans' do
  #
  #       Given(:options)  { { story: { rails: true } } }
  #       Given(:expected) { options }
  #
  #       Then { assert_equal expected, actual }
  #     end
  #
  #     describe 'contains arrays' do
  #
  #       Given(:expected) { { story: { rails: [
  #         { database: { postgresql: {} }},
  #         { ci_cd:    { circleci:   {} }}
  #       ] } } }
  #
  #       Given(:options) { { story: { rails: [
  #         { database: { 'postgresql' => {} }},
  #         { ci_cd:    { circleci:   {} }}
  #       ] } } }
  #
  #       Given(:expected)  { options }
  #
  #       Then { assert_equal expected, actual }
  #     end
    end
  end

  describe '#structure' do

    Then { assert_includes config.structure.keys, :intentions }
    And  { assert_includes config.structure.keys, :choices }
    And  { assert_includes config.structure.keys, :env_vars }

  end
end