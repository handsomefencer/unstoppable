# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  let(:subject)      { Configurator }
  let(:options)      { nil }
  let(:config)       { subject.new(options) }
  let(:catalog_root) { "#{Roro::CLI.catalog_root}" }
  let(:scene)        { catalog_root }
  let(:story_file)   { "#{Dir.pwd}/test/fixtures/files/stories/#{filename}" }

  describe '#story' do
    describe 'permitted keys' do
      Then { assert_includes config.story.keys, :actions }
      And  { assert_includes config.story.keys, :env }
      And  { assert_includes config.story.keys, :preface }
      And  { assert_includes config.story.keys, :questions }
    end

    describe 'permitted environments' do
      Then  { assert_includes config.story[:env].keys, :base }
      And   { assert_includes config.story[:env].keys, :development }
      And   { assert_includes config.story[:env].keys, :staging }
      And   { assert_includes config.story[:env].keys, :production }
    end
  end

  describe '#validate_catalog' do
    let(:catalog)   { "#{Dir.pwd}/test/fixtures/files/catalogs/#{directory}" }
    let(:execute)   { config.validate_catalog(catalog) }
    let(:error)     { Roro::Story::Empty }

    context 'when empty' do
      let(:directory) { 'invalid/directory_with_no_children' }
      let(:error_message) { 'No story in' }

      Then { assert_correct_error }
    end

    context 'when contains files with invalid extensions' do
      let(:directory) { 'invalid/directory_with_invalid_file_extensions' }
      let(:error_message) { 'contains invalid extensions' }

      Then { assert_correct_error }
    end

    context 'when valid' do
      let(:directory) { 'valid/roro' }
      let(:error_message) { 'contaissns invalid extensions' }
      focus
      Then { assert_nil execute }
    end
  end

  describe '#validate_story' do
    let(:error)    { Roro::Story::Keys }
    let(:execute)  { config.validate_story(story_file) }

    describe 'must return nil when story is valid' do
      let(:filename) { 'valid/valid.yml' }

      Then { assert_nil execute }
    end

    describe 'must return error when file' do
      context 'is empty' do
        let(:error)         { Roro::Story::Empty }
        let(:filename)      { 'invalid/empty.yml' }
        let(:error_message) { 'No content in'}

        Then { assert_correct_error }
      end

      describe 'contains unpermitted keys' do
        let(:filename)      { 'invalid/key-unpermitted.yml' }
        let(:error_message) { 'key must be in'}

        Then { assert_correct_error }
      end

      context ':env value class is' do
        context 'a String' do
          let(:filename)      { 'invalid/env-returns-string.yml' }
          let(:error_message) { 'class must be Hash, not String'}

          Then { assert_correct_error }
        end

        context 'an Array' do
          let(:filename)      { 'invalid/env-returns-array.yml' }
          let(:error_message) { 'class must be Hash, not Array'}

          Then { assert_correct_error }
        end

        context 'a Hash with' do
          context 'a key that returns a hash' do
            let(:filename)      { 'invalid/env-base-returns-string.yml' }
            let(:error_message) { 'must be Hash, not String'}

            Then { assert_correct_error }
          end

          context 'a key that returns a hash' do
            let(:filename)      { 'invalid/env-base-returns-array.yml' }
            let(:error_message) { 'must be Hash, not Array'}

            Then { assert_correct_error }
          end

          context 'unpermitted keys' do
            let(:filename)      { 'invalid/env-unpermitted.yml' }
            let(:error_message) { 'must be in'}

            Then { assert_correct_error }
          end
        end
      end

      context ':preface value class is' do
        context 'an array' do
          let(:filename)      { 'invalid/preface-returns-array.yml' }
          let(:error_message) { 'class must be String, not Array'}

          Then { assert_correct_error }
        end

        context 'a hash' do
          let(:filename)      { 'invalid/preface-returns-hash.yml' }
          let(:error_message) { 'class must be String, not Hash'}

          Then { assert_correct_error }
        end
      end

      context ':actions value class is' do
        context 'a hash' do
          let(:filename)      { 'invalid/actions-returns-hash.yml' }
          let(:error_message) { 'class must be Array, not Hash'}

          Then { assert_correct_error }
        end

        context 'string' do
          let(:filename)      { 'invalid/actions-returns-string.yml' }
          let(:error_message) { 'class must be Array, not String'}

          Then { assert_correct_error }
        end
      end

      context ':questions value class is' do
        context 'a hash' do
          let(:filename)      { 'invalid/questions-returns-hash.yml' }
          let(:error_message) { 'class must be Array, not Hash'}

          Then { assert_correct_error }
        end

        context 'string' do
          let(:filename)      { 'invalid/questions-returns-string.yml' }
          let(:error_message) { 'class must be Array, not String'}

          Then { assert_correct_error }
        end

        context 'hash without correct keys' do
          let(:filename)      { 'invalid/questions-returns-unpermitted-keys.yml' }
          let(:error_message) { 'questions key must be in'}

          Then { assert_correct_error }
        end
      end
    end
  end

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
end
