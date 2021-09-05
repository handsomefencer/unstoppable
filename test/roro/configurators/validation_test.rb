# frozen_string_literal: true

require 'test_helper'

describe 'Configurator validate_catalog' do
  let(:subject)      { Configurator }
  let(:options)      { nil }
  let(:config)       { subject.new(options) }
  let(:catalog_root) { "#{Dir.pwd}/test/fixtures/files/catalogs" }
  let(:catalog)      { "#{catalog_root}/#{node}" }
  let(:execute)      { config.validate_catalog(catalog) }
  let(:assert_valid_catalog) { -> (node) {
    catalog = "#{Dir.pwd}/test/fixtures/files/catalogs/#{node}"
    execute = config.validate_catalog(catalog)
    assert_nil execute } }

  context 'when catalog valid' do
    context 'dotfile' do
      Then { assert_valid_catalog['valid/.keep'] }
    end

    context 'story file with' do
      context '.yml extension' do
        Then { assert_valid_catalog['valid/yaml.yml'] }
      end

      context '.yaml extension' do
        Then { assert_valid_catalog['valid/yaml.yaml'] }
      end

      context ':preface hash' do
        Then { assert_valid_catalog['valid/preface_string.yml'] }
      end

      context ':questions hash' do
        Then { assert_valid_catalog['valid/questions_array.yml'] }
      end

      context ':actions array string' do
        Then { assert_valid_catalog['valid/actions_array_string.yml'] }
      end
    end
  end

  context 'when catalog invalid because node' do
    let(:error) { Roro::Error }

    context 'is not present when' do
      let(:error_message) { 'Catalog not present' }

      context 'extension is permitted' do
        When(:node) { 'invalid/nonexistent.yml' }
        Then { assert_correct_error }
      end

      context 'is a directory' do
        When(:node) { 'invalid/nonexistent' }
        Then { assert_correct_error }
      end
    end

    context 'is a story with' do
      context 'an invalid extension' do
        let(:error_message) { 'Catalog has invalid extension' }

        When(:node) { 'invalid/ruby.rb' }
        Then { assert_correct_error }
      end

      context 'no content' do
        let(:error_message) { 'Story file is empty' }

        When(:node) { 'invalid/empty.yml' }
        Then { assert_correct_error }
      end

      context 'story of hash' do
        let(:error_message) { 'must be a Hash' }

        context 'and object of a string' do
          When(:node) { 'invalid/string.yml' }
          Then { assert_correct_error }
        end

        context 'and object of an array' do
          When(:node) { 'invalid/array.yml' }
          Then { assert_correct_error }
        end

        context 'object of hash with nil value' do
          let(:error_message) { 'preface must not be nil' }

          When(:node) { 'invalid/key_with_nil_value.yml' }
          Then { assert_correct_error }
        end
      end

      context 'with unpermitted keys' do
        context 'when top level' do
          let(:error_message) { 'unpermitted keys' }

          When(:node) { 'invalid/unpermitted_keys.yml'}
          # Then { assert_correct_error }
          #
          #       # Then { assert config.has_unpermitted_keys?(content)}

        end
        #   context 'when invalid due to' do
        #     context 'unpermitted keys' do
        #     end

      end
    end
  end

  # describe '#story_file_has_unpermitted_keys?(content)' do
  #   let(:root)  { "#{Dir.pwd}/test/fixtures/files/stories" }
  #   let(:content) { config.read_yaml("#{root}/#{file}") }
  #
  #   context 'when invalid due to' do
  #     context 'unpermitted keys' do
  #       let(:file) { 'invalid/unpermitted_keys.yml'}
  #
  #       # Then { assert config.has_unpermitted_keys?(content)}
  #     end
  #
  #     context 'unpermitted question keys' do
  #       let(:file) { 'invalid/unpermitted_question_keys.yml'}
  #       let(:execute) { config.has_unpermitted_keys?(content) }
  #       let(:error)         { Roro::Catalog::ContentKeyError }
  #       let(:error_message) { "class must be , not " }
  #       # focus
  #       #
  #       # Then { assert_correct_error }
  #       #
  #       # Then { assert_correct_errorraises(Error) {  } }
  #     end
  #   end
  # end
  #
  # describe '#get_children(location)' do
  #   before { skip }
  #   let(:folder)  { "valid" }
  #   let(:execute) { config.get_children("#{catalog}") }
  #   let(:child)   { -> (child) { "#{catalog}/#{child}" } }
  #
  #   context 'when directory has one file' do
  #     let(:folder) { 'valid/roro/docker_compose'}
  #
  #     Then { assert_equal execute, [child['docker-compose.yml']] }
  #     And  { assert_equal execute.size, 1 }
  #   end
  #
  #   context 'when directory has one folder' do
  #     let(:folder) { 'valid/roro/docker_compose'}
  #
  #     Then { assert_equal execute, [child['docker-compose.yml']] }
  #     And  { assert_equal execute.size, 1 }
  #   end
  #
  #   context 'when directory has several folder' do
  #     context 'and a hidden file mustreturn one child' do
  #       let(:folder) { 'valid/roro'}
  #
  #       Then { assert_includes execute, child['k8s'] }
  #     end
  #   end
  # end
  #
  # describe '#sentence_from' do
  #   let(:call) { -> (array) { config.sentence_from(array) } }
  #
  #   Then { assert_equal 'one, two and three', call[%w(one two three)] }
  #   And  { assert_equal 'one and two', call[%w(one two)] }
  #   And  { assert_equal 'one', call[%w(one)] }
  # end
  #
  # describe '#story' do
  #   describe 'permitted keys' do
  #     Then { assert_includes config.story.keys, :actions }
  #     And  { assert_includes config.story.keys, :env }
  #     And  { assert_includes config.story.keys, :preface }
  #     And  { assert_includes config.story.keys, :questions }
  #   end
  #
  #   describe 'permitted environments' do
  #     Then  { assert_includes config.story[:env].keys, :base }
  #     And   { assert_includes config.story[:env].keys, :development }
  #     And   { assert_includes config.story[:env].keys, :staging }
  #     And   { assert_includes config.story[:env].keys, :production }
  #   end
  # end
  #
  # describe '#validate_catalog' do
  #   before { skip }
  #   let(:folder)  { "invalid" }
  #   let(:catalog) { "#{catalog_root}/#{folder}" }
  #   let(:execute) { config.validate_catalog(catalog) }
  #   let(:error)   { Roro::Catalog::Story }
  #
  #   context 'when catalog has no children' do
  #     before { skip }
  #     let(:folder)        { 'invalid/with_no_children' }
  #     let(:error_message) { 'No story in' }
  #     Then { assert_correct_error }
  #   end
  #
  #   context 'when catalog contains files with invalid extensions' do
  #     let(:folder) { 'invalid/with_invalid_extensions' }
  #     let(:error_message) { 'contains invalid extensions' }
  #
  #     Then { assert_correct_error }
  #   end
  #
  #   context 'when valid' do
  #     let(:directory) { 'valid/roro' }
  #
  #     Then { assert_valid }
  #   end
  # end
  #
  # describe '#validate_story' do
  #   before { skip }
  #   let(:error)    { Roro::Catalog::Keys }
  #   let(:execute)  { config.validate_story(story_file) }
  #
  #   describe 'must return nil when story is valid' do
  #     let(:filename) { 'valid/valid.yml' }
  #
  #     Then { assert_valid }
  #   end
  #
  #   describe 'must return error when file' do
  #     before { skip }
  #
  #     describe 'contains unpermitted keys' do
  #       let(:filename)      { 'invalid/unpermitted_keys.yml' }
  #       let(:error_message) { 'key must be in'}
  #
  #       Then { assert_correct_error }
  #     end
  #
  #     context ':env value class is' do
  #       context 'a String' do
  #         let(:filename)      { 'invalid/env-returns-string.yml' }
  #         let(:error_message) { 'class must be Hash, not String'}
  #
  #         Then { assert_correct_error }
  #       end
  #
  #       context 'an Array' do
  #         let(:error) { Roro::Story::Keys }
  #         let(:filename)      { 'invalid/env-returns-array.yml' }
  #         let(:error_message) { 'class must be Hash, not Array'}
  #
  #         Then { assert_correct_error }
  #       end
  #
  #       context 'a Hash with' do
  #         context 'a key that returns a string' do
  #           let(:filename)      { 'invalid/env-base-returns-string.yml' }
  #           let(:error_message) { 'must be Hash, not String'}
  #
  #           Then { assert_correct_error }
  #         end
  #
  #         context 'a key that returns an array' do
  #           let(:filename)      { 'invalid/env-base-returns-array.yml' }
  #           let(:error_message) { 'must be Hash, not Array'}
  #
  #           Then { assert_correct_error }
  #         end
  #
  #         context 'unpermitted keys' do
  #           let(:filename)      { 'invalid/env-unpermitted.yml' }
  #           let(:error_message) { 'must be in'}
  #
  #           Then { assert_correct_error }
  #         end
  #       end
  #     end
  #
  #     context ':preface value class is' do
  #       context 'an array' do
  #         let(:filename)      { 'invalid/preface-returns-array.yml' }
  #         let(:error_message) { 'class must be String, not Array'}
  #
  #         Then { assert_correct_error }
  #       end
  #
  #       context 'a hash' do
  #         let(:filename)      { 'invalid/preface-returns-hash.yml' }
  #         let(:error_message) { 'class must be String, not Hash'}
  #
  #         Then { assert_correct_error }
  #       end
  #     end
  #
  #     context ':actions value class is' do
  #       context 'a hash' do
  #         let(:filename)      { 'invalid/actions-returns-hash.yml' }
  #         let(:error_message) { 'class must be Array, not Hash'}
  #
  #         Then { assert_correct_error }
  #       end
  #
  #       context 'string' do
  #         let(:filename)      { 'invalid/actions-returns-string.yml' }
  #         let(:error_message) { 'class must be Array, not String'}
  #
  #         Then { assert_correct_error }
  #       end
  #     end
  #
  #     context ':questions value class is' do
  #       context 'a hash' do
  #         let(:filename)      { 'invalid/questions-returns-hash.yml' }
  #         let(:error_message) { 'class must be Array, not Hash'}
  #
  #         Then { assert_correct_error }
  #       end
  #
  #       context 'string' do
  #         let(:filename)      { 'invalid/questions-returns-string.yml' }
  #         let(:error_message) { 'class must be Array, not String'}
  #
  #         Then { assert_correct_error }
  #       end
  #
  #       context 'hash without correct keys' do
  #         let(:filename)      { 'invalid/unpermitted_question_keys.yml' }
  #         let(:error_message) { 'questions key must be in'}
  #
  #         Then { assert_correct_error }
  #       end
  #     end
  #   end
  # end
  #
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
