# # frozen_string_literal: true

require 'test_helper'

describe Validator do
  Given(:args)      { nil }
  Given(:validator) { Validator.new(*args) }
  Given { use_stub_stack }

  context 'when no args supplied' do
    describe '#initialize' do
      describe '#stack' do
        Then { assert_equal Roro::CLI.stacks, validator.stack }
      end

      describe '#permitted_hidden_extensions' do
        Then do
          assert_equal %w[.keep .gitkeep],
                       validator.permitted_hidden_extensions
        end
      end

      describe '#permitted_story_extensions' do
        Then do
          assert_equal %w[yml yaml],
                       validator.permitted_story_extensions
        end
      end

      describe '#structure' do
        Then { assert_equal Hash, validator.structure.class }
      end
    end

    describe '#validate' do
      Then { assert_valid_stack }
    end
  end

  describe '#validate' do
    context 'when valid' do
      context 'templates folder' do
        When(:stack) { 'templates' }
        Then { assert_valid_stack }
      end

      context 'inflection folder' do
        When(:stack) { 'stacks' }
        Then { assert_valid_stack }
      end

      context 'nested stack folder' do
        When(:stack) { 'stack' }
        Then { assert_valid_stack }
      end

      context 'hidden .keep file' do
        When(:stack) { 'story/.keep' }
        Then { assert_valid_stack }
      end

      context 'hidden .gitkeep file' do
        When(:stack) { 'story/.gitkeep' }
        Then { assert_valid_stack }
      end

      context 'story file when' do
        context '.yaml extension' do
          When(:stack) { 'story/yaml.yaml' }
          Then { assert_valid_stack }
        end

        context '.yml extension' do
          When(:stack) { 'story/yaml.yml' }
          Then { assert_valid_stack }
        end

        context 'plot top level is a hash' do
          When(:stack) { 'story/hash.yml' }
          Then { assert_valid_stack }

          context 'when :preface returns a string' do
            When(:stack) { 'story/valid_preface.yml' }
            Then { assert_valid_stack }
          end

          context 'when :questions returns an array of hashes' do
            When(:stack) { 'story/valid_questions.yml' }
            Then { assert_valid_stack }
          end

          context 'when :actions returns an array of strings' do
            When(:stack) { 'story/valid_actions.yml' }
            Then { assert_valid_stack }
          end

          context 'when :env returns a hash of hashes' do
            When(:stack) { 'story/valid_env.yml' }
            Then { assert_valid_stack }
          end
        end
      end
    end

    context 'when invalid' do
      Given(:execute)   { validator.validate(stack_path(:invalid)) }
      Given(:error_msg) { 'Catalog not present' }

      context 'nonexistent file with permitted extension' do
        When(:stack) { 'nonexistent.yml' }
        Then { assert_correct_error }
      end

      context 'nonexistent file with an unpermitted extension' do
        When(:stack) { 'nonexistent.non' }
        Then { assert_correct_error }
      end

      context 'nonexistent folder' do
        When(:stack) { 'nonexistent' }
        Then { assert_correct_error }
      end

      context 'empty folder' do
        When(:stack)     { 'empty' }
        When(:error_msg) { 'Catalog cannot be an empty folder' }
        Then { assert_correct_error }
      end

      context 'file with an unpermitted extension' do
        When(:error_msg) { 'Catalog has unpermitted extension' }
        When(:stack) { 'ruby.rb' }
        Then { assert_correct_error }
      end

      context 'storyfile when' do
        context 'content is empty' do
          When(:error_msg) { 'Story file is empty' }
          When(:stack)     { 'story_without_content/story_without_content.yml' }
          Then { assert_correct_error }
        end

        context 'top level content is' do
          Given(:error_msg) { 'must be an instance of Hash' }

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
            When(:stack) { 'actions/empty_array.yml' }
            Then { assert_correct_error }
          end

          context 'an array of' do
            Given(:error_msg) { 'must be an instance of String' }

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
          Given(:error_msg) { 'must be an instance of Hash' }

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
          Given(:error_msg) { 'not in permitted' }

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
