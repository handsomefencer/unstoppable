# # frozen_string_literal: true

require 'test_helper'

describe 'Validator#validate_stack' do
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

  # context 'valid when stack is a' do
  #   before { skip }
  #   context 'folder and' do
  #     context 'when template' do
  #       Then { assert_valid_stack('stack/story/templates') }
  #     end
  #
  #     context 'when inflection' do
  #       Then { assert_valid_stack('stack/inflection') }
  #     end
  #
  #     context 'when valid (roro example)' do
  #       Then { assert_valid_stack('roro') }
  #     end
  #   end
  #
  #   describe 'story file and' do
  #     let(:stack_root) { "#{Dir.pwd}/test/fixtures/stacks/story" }
  #
  #     context 'when .keep' do
  #       Then { assert_valid_stack('top_level/.keep') }
  #     end
  #
  #     context 'when .gitkeep' do
  #       Then { assert_valid_stack('top_level/.gitkeep') }
  #     end
  #
  #     context 'when .yml extension' do
  #       Then { assert_valid_stack('top_level/yaml.yml') }
  #     end
  #
  #     context 'when .yaml extension' do
  #       Then { assert_valid_stack('top_level/yaml.yaml') }
  #     end
  #
  #     context 'when contains content and' do
  #       context 'when top level is a hash' do
  #         Then { assert_valid_stack('top_level/hash.yml') }
  #       end
  #
  #       context 'when :preface value is string' do
  #         Then { assert_valid_stack('preface/valid.yml') }
  #       end
  #
  #       context 'when :questions value is array of hashes' do
  #         Then { assert_valid_stack('questions/valid.yml') }
  #       end
  #
  #       context 'when :actions value is array of strings' do
  #         Then { assert_valid_stack('actions/valid.yml') }
  #       end
  #
  #       context 'when :env value is hash of hashes' do
  #         Then { assert_valid_stack('env/valid.yml') }
  #       end
  #     end
  #   end
  # end

  context 'invalid' do
    let(:execute)   { validator.validate(stack_path(:invalid)) }
    let(:error_msg) { 'Catalog not present' }

    context 'when stack is a nonexistent file when extension is' do
      context 'permitted' do
        When(:stack) { 'nonexistent.yml' }
        Then { assert_correct_error }
      end

      context 'not permitted' do
        When(:stack) { 'nonexistent.non' }
        Then { assert_correct_error }
      end
    end

    context 'when stack is a nonexistent folder' do
      When(:stack) { 'nonexistent' }
      Then { assert_correct_error }
    end

    context 'when stack is an empty folder' do
      When(:stack)     { 'empty' }
      When(:error_msg) { 'Catalog cannot be an empty folder' }
      Then { assert_correct_error }
    end

    context 'when stack is a file with an unpermitted extension' do
      When(:error_msg) { 'Catalog has unpermitted extension' }
      When(:stack) { 'ruby.rb' }
      Then { assert_correct_error }
    end

    describe 'when stack is a storyfile' do
      context 'when empty' do
        When(:error_msg) { 'Story file is empty' }
        When(:stack)     { 'story_without_content/story_without_content.yml' }
        Then { assert_correct_error }
      end

      context 'when top level content is a' do
        let(:error_msg) { 'must be an instance of Hash' }

        context 'string' do
          When(:stack) { 'top_level/string.yml' }
          Then { assert_correct_error }
        end

        context 'array' do
          When(:stack) { 'top_level/array.yml' }
          Then { assert_correct_error }
        end
      end

      context 'when :actions value is' do
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

      context 'when :env value is' do
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

      context 'when :preface when value is' do
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

      context 'when :questions when value is' do
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

      context 'with unpermitted keys' do
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
