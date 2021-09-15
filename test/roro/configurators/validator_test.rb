# # frozen_string_literal: true

require 'test_helper'

describe 'validate catalog structure' do
  let(:validator)    { Validator.new }
  let(:catalog_path) { "#{catalog_root}/#{catalog}" }
  let(:execute)      { validator.validate_catalog(catalog_path) }
  let(:assert_valid_catalog) do
    lambda do |node|
      catalog = "#{catalog_root}/#{node}"
      execute = validator.validate_catalog(catalog)
      assert_nil execute
    end
  end

  context 'valid when catalog is a' do
    describe 'folder and' do
      let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }

      context 'when template' do
        Then { assert_valid_catalog['templates'] }
      end

      context 'when inflection' do
        Then { assert_valid_catalog['inflection'] }
      end

      context 'when valid (roro example)' do
        Then { assert_valid_catalog['roro'] }
      end
    end

    describe 'story file and' do
      let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/story" }

      context 'when .keep' do
        Then { assert_valid_catalog['top_level/.keep'] }
      end

      context 'when .gitkeep' do
        Then { assert_valid_catalog['top_level/.gitkeep'] }
      end

      context 'when .yml extension' do
        Then { assert_valid_catalog['top_level/yaml.yml'] }
      end

      context 'when .yaml extension' do
        Then { assert_valid_catalog['top_level/yaml.yaml'] }
      end

      context 'when contains content and' do
        context 'when top level is a hash' do
          Then { assert_valid_catalog['top_level/hash.yml'] }
        end

        context 'when :preface value is string' do
          Then { assert_valid_catalog['preface/valid.yml'] }
        end

        context 'when :questions value is array of hashes' do
          Then { assert_valid_catalog['questions/valid.yml'] }
        end

        context 'when :actions value is array of strings' do
          Then { assert_valid_catalog['actions/valid.yml'] }
        end

        context 'when :env value is hash of hashes' do
          Then { assert_valid_catalog['env/valid.yml'] }
        end
      end
    end
  end

  context 'invalid when catalog is a' do
    let(:error) { Roro::Error }
    let(:error_message) { 'Catalog not present' }

    context 'folder and' do
      let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/structure" }

      context 'when empty' do
        When(:error_message) { 'Catalog cannot be an empty folder' }
        When(:catalog) { 'empty' }
        Then { assert_correct_error }
      end

      context 'when nonexistent' do
        Then { assert_correct_error }
        When(:catalog) { 'nonexistent' }
      end
    end

    describe 'story' do
      let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs/story" }

      context 'when nonexistent with a permitted file extension' do
        When(:catalog) { 'nonexistent.yml' }
        Then { assert_correct_error }
      end

      context 'when unpermitted extension' do
        When(:error_message) { 'Catalog has unpermitted extension' }
        When(:catalog) { 'top_level/ruby.rb' }
        Then { assert_correct_error }
      end

      context 'when empty' do
        When(:error_message) { 'Story file is empty' }
        When(:catalog) { 'top_level/empty.yml' }
        Then { assert_correct_error }
      end

      context 'when top level content is a' do
        let(:error_message) { 'must be an instance of Hash' }

        context 'string' do
          When(:catalog) { 'top_level/string.yml' }
          Then { assert_correct_error }
        end

        context 'array' do
          When(:catalog) { 'top_level/array.yml' }
          Then { assert_correct_error }
        end
      end

      context 'when :actions value is' do
        context 'nil' do
          When(:error_message) { 'Value for :actions must not be nil' }
          When(:catalog) { 'actions/nil_value.yml' }
          Then { assert_correct_error }
        end

        context 'a hash' do
          When(:error_message) { 'must be an instance of Array' }
          When(:catalog) { 'actions/hash.yml' }
          Then { assert_correct_error }
        end

        context 'a string' do
          When(:error_message) { 'must be an instance of Array' }
          When(:catalog) { 'actions/string.yml' }
          Then { assert_correct_error }
        end

        context 'an empty array' do
          let(:error_message) { 'Story contains an empty array' }

          When(:catalog) { 'actions/empty_array.yml' }
          Then { assert_correct_error }
        end

        context 'an array of' do
          let(:error_message) { 'must be an instance of String' }

          context 'hashes' do
            When(:catalog) { 'actions/array_of_hashes.yml' }
            Then { assert_correct_error }
          end

          context 'arrays' do
            let(:error_message) { 'must be an instance of String' }

            When(:catalog) { 'actions/array_of_arrays.yml' }
            Then { assert_correct_error }
          end
        end
      end

      context 'when :env value is' do
        let(:error_message) { 'must be an instance of Hash' }

        context 'nil' do
          When(:error_message) { 'Value for :actions must not be nil' }
          When(:catalog) { 'actions/nil_value.yml' }
          Then { assert_correct_error }
        end

        context 'a string' do
          When(:catalog) { 'env/string.yml' }
          Then { assert_correct_error }
        end

        context 'an array' do
          When(:catalog) { 'env/array.yml' }
          Then { assert_correct_error }
        end

        context 'a hash of arrays' do
          When(:catalog) { 'env/hash_of_arrays.yml' }
          Then { assert_correct_error }
        end
      end

      context 'when :preface when value is' do
        context 'nil' do
          When(:error_message) { 'Value for :preface must not be nil' }
          When(:catalog) { 'preface/nil_value.yml' }
          Then { assert_correct_error }
        end

        context 'an array' do
          When(:error_message) { 'must be an instance of String' }
          When(:catalog) { 'preface/array.yml' }
          Then { assert_correct_error }
        end

        context 'a hash' do
          When(:error_message) { 'must be an instance of String' }
          When(:catalog) { 'preface/hash.yml' }
          Then { assert_correct_error }
        end
      end

      context 'when :questions when value is' do
        context 'nil' do
          When(:error_message) { 'must not be nil' }
          When(:catalog) { 'questions/nil_value.yml' }
          Then { assert_correct_error }
        end

        context 'a string' do
          When(:error_message) { 'must be an instance of Array' }
          When(:catalog) { 'questions/string.yml' }
          Then { assert_correct_error }
        end

        context 'a hash' do
          When(:error_message) { 'must be an instance of Array' }
          When(:catalog) { 'questions/hash.yml' }
          Then { assert_correct_error }
        end

        context 'an array' do
          context 'of strings' do
            When(:error_message) { 'must be an instance of Hash' }
            When(:catalog) { 'questions/array_of_strings.yml' }
            Then { assert_correct_error }
          end

          context 'of arrays' do
            When(:error_message) { 'must be an instance of Hash' }
            When(:catalog) { 'questions/array_of_arrays.yml' }
            Then { assert_correct_error }
          end
        end
      end

      context 'with unpermitted keys' do
        let(:error_message) { 'not in permitted' }

        context 'when top level' do
          When(:catalog) { 'top_level/unpermitted_keys.yml' }
          Then { assert_correct_error }
        end

        context 'when :questions' do
          When(:catalog) { 'questions/unpermitted_keys.yml' }
          Then { assert_correct_error }
        end
      end
    end
  end
end
