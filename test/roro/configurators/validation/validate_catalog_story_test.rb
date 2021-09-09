# frozen_string_literal: true

require 'test_helper'

describe 'Configurator validate_catalog' do
  let(:subject)      { Configurator }
  let(:options)      { nil }
  let(:config)       { subject.new(options) }
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/story" }
  let(:catalog)      { "#{catalog_root}/#{node}" }
  let(:execute)      { config.validate_catalog(catalog) }
  let(:assert_valid_catalog) do
    lambda { |node|
      catalog = "#{catalog_root}/#{node}"
      execute = config.validate_catalog(catalog)
      assert_nil execute
    }
  end

  describe 'valid' do
    context 'dotfile' do
      Then { assert_valid_catalog['top_level/.keep'] }
      And  { assert_valid_catalog['top_level/.gitkeep'] }
    end

    context 'story file with' do
      Then { assert_valid_catalog['top_level/yaml.yml'] }
      And  { assert_valid_catalog['top_level/yaml.yaml'] }

      context 'top level' do
        Then { assert_valid_catalog['top_level/hash.yml'] }
      end

      context ':preface value is string' do
        Then { assert_valid_catalog['preface/valid.yml'] }
      end

      context ':questions value is array of hashes' do
        Then { assert_valid_catalog['questions/valid.yml'] }
      end

      context ':actions value is array of strings' do
        Then { assert_valid_catalog['actions/valid.yml'] }
      end

      context ':env value is hash of hashes' do
        Then { assert_valid_catalog['env/valid.yml'] }
      end
    end
  end

  context 'invalid' do
    let(:error) { Roro::Error }

    context 'catalog not present' do
      let(:error_message) { 'Catalog not present' }

      context 'when valid story file extension' do
        When(:node) { 'nonexistent.yml' }
        Then { assert_correct_error }
      end

      context 'is a directory' do
        When(:node) { 'nonexistent' }
        Then { assert_correct_error }
      end
    end

    context 'story with' do
      let(:node) { story }

      context 'unpermitted extension' do
        let(:error_message) { 'Catalog has unpermitted extension' }

        When(:story) { 'top_level/ruby.rb' }
        Then { assert_correct_error }
      end

      context 'is empty' do
        let(:error_message) { 'Story file is empty' }

        When(:story) { 'top_level/empty.yml' }
        Then { assert_correct_error }
      end

      context 'top level with' do
        let(:error_message) { 'must be an instance of Hash' }

        context 'string' do
          When(:story) { 'top_level/string.yml' }
          Then { assert_correct_error }
        end

        context 'array' do
          When(:story) { 'top_level/array.yml' }
          Then { assert_correct_error }
        end
      end

      context ':actions value is' do
        context 'nil' do
          let(:error_message) { 'Value for :actions must not be nil' }

          When(:node) { 'actions/nil_value.yml' }
          Then { assert_correct_error }
        end

        context 'a hash' do
          let(:error_message) { 'must be an instance of Array' }

          When(:node) { 'actions/hash.yml' }

          Then { assert_correct_error }
        end

        context 'a string' do
          let(:error_message) { 'must be an instance of Array' }

          When(:node) { 'actions/string.yml' }
          Then { assert_correct_error }
        end

        context 'an empty array' do
          let(:error_message) { 'Story contains an empty array' }

          When(:story) { 'actions/empty_array.yml' }
          Then { assert_correct_error }
        end

        context 'an array of' do
          let(:error_message) { 'must be an instance of String' }

          context 'hashes' do
            When(:node) { 'actions/array_of_hashes.yml' }
            Then { assert_correct_error }
          end

          context 'arrays' do
            let(:error_message) { 'must be an instance of String' }

            When(:node) { 'actions/array_of_arrays.yml' }
            Then { assert_correct_error }
          end
        end
      end

      context ':env value is' do
        let(:error_message) { 'must be an instance of Hash' }

        context 'nil' do
          let(:error_message) { 'Value for :actions must not be nil' }

          When(:node) { 'actions/nil_value.yml' }
          Then { assert_correct_error }
        end

        context 'a string' do
          When(:node) { 'env/string.yml' }
          Then { assert_correct_error }
        end

        context 'an array' do
          When(:node) { 'env/array.yml' }
          Then { assert_correct_error }
        end

        context 'a hash of' do
          context 'arrays' do
            When(:node) { 'env/hash_of_arrays.yml' }
            Then { assert_correct_error }
          end
        end
      end

      context ':preface when value is' do
        context 'nil' do
          let(:error_message) { 'Value for :preface must not be nil' }

          When(:node) { 'preface/nil_value.yml' }
          Then { assert_correct_error }
        end

        context 'array' do
          let(:error_message) { 'must be an instance of String' }

          When(:node) { 'preface/array.yml' }
          Then { assert_correct_error }
        end

        context 'hash' do
          let(:error_message) { 'must be an instance of String' }

          When(:node) { 'preface/hash.yml' }
          Then { assert_correct_error }
        end
      end

      context ':questions when value is' do
        context 'nil' do
          let(:error_message) { 'must not be nil' }

          When(:node) { 'questions/nil_value.yml' }
          Then { assert_correct_error }
        end

        context 'a string' do
          let(:error_message) { 'must be an instance of Array' }

          When(:node) { 'questions/string.yml' }
          Then { assert_correct_error }
        end

        context 'a hash' do
          let(:error_message) { 'must be an instance of Array' }

          When(:node) { 'questions/hash.yml' }
          Then { assert_correct_error }
        end

        context 'an array' do
          context 'of strings' do
            let(:error_message) { 'must be an instance of Hash' }

            When(:node) { 'questions/array_of_strings.yml' }
            Then { assert_correct_error }
          end

          context 'of arrays' do
            let(:error_message) { 'must be an instance of Hash' }

            When(:node) { 'questions/array_of_arrays.yml' }
            Then { assert_correct_error }
          end
        end
      end

      context 'with unpermitted keys' do
        let(:error_message) { 'not in permitted' }

        context 'when top level' do
          When(:node) { 'top_level/unpermitted_keys.yml' }
          Then { assert_correct_error }
        end

        context 'when :questions' do
          When(:node) { 'questions/unpermitted_keys.yml' }
          Then { assert_correct_error }
        end
      end
    end
  end

end
