# # frozen_string_literal: true

require 'test_helper'

describe Validator do
  let(:validator) { Validator.new }
  let(:validate)  { validator.validate_stack(stack_path) }

  describe '#initialize' do
    describe '#catalog' do
      Then { assert_equal Roro::CLI.catalog_root, validator.stack }
    end

    describe '#permitted_extensions' do
      Then { assert_equal %w[yml yaml], validator.ext_story }
      Then { assert_equal %w[.keep .gitkeep], validator.ext_hidden }
    end

    describe '#structure' do
      Then { assert_equal Hash, validator.structure.class }
    end
  end

  describe '#validate' do
    context 'when stack is valid' do
      context 'templates folder' do
        Then { assert_valid_stack('templates') }
      end

      context 'inflection folder' do
        Then { assert_valid_stack('stacks') }
      end

      context 'nested stack folder' do
        Then { assert_valid_stack('stack') }
      end

      context 'hidden file' do
        Then { assert_valid_stack('story/.keep') }
        And  { assert_valid_stack('story/.gitkeep') }
      end

      context 'story file' do
        Then { assert_valid_stack('story/yaml.yml') }
        And  { assert_valid_stack('story/yaml.yaml') }
      end

      context 'story file with plot' do
        context 'when top level is a hash' do
          Then { assert_valid_stack('story/hash.yml') }
        end

        context 'when :preface returns a string' do
          Then { assert_valid_stack('story/valid_preface.yml') }
        end

        context 'when :questions returns an array of hashes' do
          Then { assert_valid_stack('story/valid_questions.yml') }
        end

        context 'when :actions returns an array of strings' do
          Then { assert_valid_stack('story/valid_actions.yml') }
        end

        context 'when :env returns a hash of hashes' do
          Then { assert_valid_stack('story/valid_env.yml') }
        end
      end
    end

    context 'when stack is invalid' do
      let(:execute)   { validator.validate(stack_path(:invalid)) }
      let(:error_msg) { 'Catalog not present' }

      context 'nonexistent when' do
        context 'file with permitted extension' do
          When(:stack) { 'nonexistent.yml' }
          Then { assert_correct_error }
        end

        context 'file with an unpermitted extension' do
          When(:stack) { 'nonexistent.non' }
          Then { assert_correct_error }
        end

        context 'folder' do
          When(:stack) { 'nonexistent' }
          Then { assert_correct_error }
        end
      end

      context 'empty folder' do
        When(:stack)     { 'empty' }
        When(:error_msg) { 'Catalog cannot be an empty folder' }
        Then { assert_correct_error }
      end

      context 'a file with an unpermitted extension' do
        When(:error_msg) { 'Catalog has unpermitted extension' }
        When(:stack) { 'ruby.rb' }
        Then { assert_correct_error }
      end

      context 'a storyfile when' do
        context 'content empty' do
          When(:error_msg) { 'Story file is empty' }
          When(:stack)     { 'story_without_content/story_without_content.yml' }
          Then { assert_correct_error }
        end

        context 'top level content is' do
          let(:error_msg) { 'must be an instance of Hash' }

          context 'a string' do
            When(:stack) { 'top_level/string.yml' }
            Then { assert_correct_error }
          end

          context 'an array' do
            When(:stack) { 'top_level/array.yml' }
            Then { assert_correct_error }
          end
        end

        context ':actions returns' do
          context 'nil' do
            When(:error_msg) { 'Value for :actions must not be nil' }
            When(:stack)     { 'actions/nil_value.yml' }
            Then { assert_correct_error }
          end

          context 'a hash' do
            When(:error_msg) { 'must be an instance of Array' }
            When(:stack)     { 'actions/hash.yml' }
            Then { assert_correct_error }
          end

          context 'a string' do
            When(:error_msg) { 'must be an instance of Array' }
            When(:stack)     { 'actions/string.yml' }
            Then { assert_correct_error }
          end

          context 'an empty array' do
            When(:error_msg) { 'Story contains an empty array' }
            When(:stack  )   { 'actions/empty_array.yml' }
            Then { assert_correct_error }
          end

          context 'an array of' do
            let(:error_msg) { 'must be an instance of String' }

            context 'hashes' do
              When(:stack) { 'actions/array_of_hashes.yml' }
              Then { assert_correct_error }
            end

            context 'arrays' do
              When(:stack) { 'actions/array_of_arrays.yml' }
              Then { assert_correct_error }
            end
          end
        end

        context ':env returns' do
          let(:error_msg) { 'must be an instance of Hash' }

          context 'nil' do
            When(:error_msg) { 'Value for :actions must not be nil' }
            When(:stack)     { 'actions/nil_value.yml' }
            Then { assert_correct_error }
          end

          context 'a string' do
            When(:stack) { 'env/string.yml' }
            Then { assert_correct_error }
          end

          context 'an array' do
            When(:stack) { 'env/array.yml' }
            Then { assert_correct_error }
          end

          context 'a hash of arrays' do
            When(:stack) { 'env/hash_of_arrays.yml' }
            Then { assert_correct_error }
          end
        end

        context ':preface returns' do
          context 'nil' do
            When(:error_msg) { 'Value for :preface must not be nil' }
            When(:stack)     { 'preface/nil_value.yml' }
            Then { assert_correct_error }
          end

          context 'an array' do
            When(:error_msg) { 'must be an instance of String' }
            When(:stack)     { 'preface/array.yml' }
            Then { assert_correct_error }
          end

          context 'a hash' do
            When(:error_msg) { 'must be an instance of String' }
            When(:stack) { 'preface/hash.yml' }
            Then { assert_correct_error }
          end
        end

        context ':questions returns' do
          context 'nil' do
            When(:error_msg) { 'must not be nil' }
            When(:stack)     { 'questions/nil_value.yml' }
            Then { assert_correct_error }
          end

          context 'a string' do
            When(:error_msg) { 'must be an instance of Array' }
            When(:stack)     { 'questions/string.yml' }
            Then { assert_correct_error }
          end

          context 'a hash' do
            When(:error_msg) { 'must be an instance of Array' }
            When(:stack)     { 'questions/hash.yml' }
            Then { assert_correct_error }
          end

          context 'an array' do
            context 'of strings' do
              When(:error_msg) { 'must be an instance of Hash' }
              When(:stack)     { 'questions/array_of_strings.yml' }
              Then { assert_correct_error }
            end

            context 'of arrays' do
              When(:error_msg) { 'must be an instance of Hash' }
              When(:stack)     { 'questions/array_of_arrays.yml' }
              Then { assert_correct_error }
            end
          end
        end

        context 'unpermitted keys' do
          let(:error_msg) { 'not in permitted' }

          context 'when top level' do
            When(:stack) { 'top_level/unpermitted_keys.yml' }
            Then { assert_correct_error }
          end

          context 'when :questions' do
            When(:stack) { 'questions/unpermitted_keys.yml' }
            Then { assert_correct_error }
          end
        end
      end
    end
  end
end
