# # frozen_string_literal: true
#
# require 'test_helper'
#
# describe 'Configurator validate_catalog structure' do
#   let(:subject)      { Configurator }
#   let(:options)      { nil }
#   let(:config)       { subject.new(options) }
#   let(:catalog_root) { "#{Dir.pwd}/test/fixtures/catalogs" }
#   let(:catalog)      { "#{catalog_root}/#{node}" }
#   let(:execute)      { config.validate_catalog(catalog) }
#   let(:assert_valid_catalog) do
#     lambda { |node|
#       catalog = "#{catalog_root}/#{node}"
#       execute = config.validate_catalog(catalog)
#       assert_nil execute
#     }
#   end
#
#   describe 'valid' do
#     context 'dotfile' do
#       Then { assert_valid_catalog['top_level/.keep'] }
#       And  { assert_valid_catalog['top_level/.gitkeep'] }
#     end
#
#     context 'story file with' do
#       Then { assert_valid_catalog['top_level/yaml.yml'] }
#       And  { assert_valid_catalog['top_level/yaml.yaml'] }
#
#       context 'top level' do
#         Then { assert_valid_catalog['top_level/hash.yml'] }
#       end
#
#       context ':preface value is string' do
#         Then { assert_valid_catalog['preface/valid.yml'] }
#       end
#
#       context ':questions value is array of hashes' do
#         Then { assert_valid_catalog['questions/valid.yml'] }
#       end
#
#       context ':actions value is array of strings' do
#         Then { assert_valid_catalog['actions/valid.yml'] }
#       end
#
#       context ':env value is hash of hashes' do
#         Then { assert_valid_catalog['env/valid.yml'] }
#       end
#     end
#   end
#
#   context 'invalid' do
#     let(:error) { Roro::Error }
#
#     context 'catalog not present' do
#       let(:error_message) { 'Catalog not present' }
#
#       context 'when valid story file extension' do
#         When(:node) { 'nonexistent.yml' }
#         Then { assert_correct_error }
#       end
#
#       context 'is a directory' do
#         When(:node) { 'nonexistent' }
#         Then { assert_correct_error }
#       end
#     end
#
#     context 'story with' do
#       let(:node) { story }
#
#       context 'unpermitted extension' do
#         let(:error_message) { 'Catalog has invalid extension' }
#
#         When(:story) { 'top_level/ruby.rb' }
#         Then { assert_correct_error }
#       end
#
#       context 'is empty' do
#         let(:error_message) { 'Story file is empty' }
#
#         When(:story) { 'top_level/empty.yml' }
#         Then { assert_correct_error }
#       end
#
#       context 'top level with' do
#         let(:error_message) { 'must be an instance of Hash' }
#
#         context 'string' do
#           When(:story) { 'top_level/string.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'array' do
#           When(:story) { 'top_level/array.yml' }
#           Then { assert_correct_error }
#         end
#       end
#
#       context ':actions value is' do
#         context 'nil' do
#           let(:error_message) { 'Value for :actions must not be nil' }
#
#           When(:node) { 'actions/nil_value.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'a hash' do
#           let(:error_message) { 'must be an instance of Array' }
#
#           When(:node) { 'actions/hash.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'a string' do
#           let(:error_message) { 'must be an instance of Array' }
#
#           When(:node) { 'actions/string.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'an empty array' do
#           let(:error_message) { 'Story contains an empty array' }
#
#           When(:story) { 'actions/empty_array.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'an array of' do
#           let(:error_message) { 'must be an instance of String' }
#
#           context 'hashes' do
#             When(:node) { 'actions/array_of_hashes.yml' }
#             Then { assert_correct_error }
#           end
#
#           context 'arrays' do
#             let(:error_message) { 'must be an instance of String' }
#
#             When(:node) { 'actions/array_of_arrays.yml' }
#             Then { assert_correct_error }
#           end
#         end
#       end
#
#       context ':env value is' do
#         let(:error_message) { 'must be an instance of Hash' }
#
#         context 'nil' do
#           let(:error_message) { 'Value for :actions must not be nil' }
#
#           When(:node) { 'actions/nil_value.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'a string' do
#           When(:node) { 'env/string.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'an array' do
#           When(:node) { 'env/array.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'a hash of' do
#           context 'arrays' do
#             When(:node) { 'env/hash_of_arrays.yml' }
#             Then { assert_correct_error }
#           end
#         end
#       end
#
#       context ':preface when value is' do
#         context 'nil' do
#           let(:error_message) { 'Value for :preface must not be nil' }
#
#           When(:node) { 'preface/nil_value.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'array' do
#           let(:error_message) { 'must be an instance of String' }
#
#           When(:node) { 'preface/array.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'hash' do
#           let(:error_message) { 'must be an instance of String' }
#
#           When(:node) { 'preface/hash.yml' }
#           Then { assert_correct_error }
#         end
#       end
#
#       context ':questions when value is' do
#         context 'nil' do
#           let(:error_message) { 'must not be nil' }
#
#           When(:node) { 'questions/nil_value.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'a string' do
#           let(:error_message) { 'must be an instance of Array' }
#
#           When(:node) { 'questions/string.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'a hash' do
#           let(:error_message) { 'must be an instance of Array' }
#
#           When(:node) { 'questions/hash.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'an array' do
#           context 'of strings' do
#             let(:error_message) { 'must be an instance of Hash' }
#
#             When(:node) { 'questions/array_of_strings.yml' }
#             Then { assert_correct_error }
#           end
#
#           context 'of arrays' do
#             let(:error_message) { 'must be an instance of Hash' }
#
#             When(:node) { 'questions/array_of_arrays.yml' }
#             Then { assert_correct_error }
#           end
#         end
#       end
#
#       context 'with unpermitted keys' do
#         context 'when top level' do
#           let(:error_message) { 'not permitted' }
#
#           When(:node) { 'top_level/unpermitted_keys.yml' }
#           Then { assert_correct_error }
#         end
#
#         context 'when :questions' do
#           let(:error_message) { 'not permitted' }
#
#           When(:node) { 'questions/unpermitted_keys.yml' }
#           Then { assert_correct_error }
#         end
#       end
#     end
#   end
#   # describe '#get_children(location)' do
#   #   before { skip }
#   #   let(:folder)  { "valid" }
#   #   let(:execute) { config.get_children("#{catalog}") }
#   #   let(:child)   { -> (child) { "#{catalog}/#{child}" } }
#   #
#   #   context 'when directory has one file' do
#   #     let(:folder) { 'valid/roro/docker_compose'}
#   #
#   #     Then { assert_equal execute, [child['docker-compose.yml']] }
#   #     And  { assert_equal execute.size, 1 }
#   #   end
#   #
#   #   context 'when directory has one folder' do
#   #     let(:folder) { 'valid/roro/docker_compose'}
#   #
#   #     Then { assert_equal execute, [child['docker-compose.yml']] }
#   #     And  { assert_equal execute.size, 1 }
#   #   end
#   #
#   #   context 'when directory has several folder' do
#   #     context 'and a hidden file mustreturn one child' do
#   #       let(:folder) { 'valid/roro'}
#   #
#   #       Then { assert_includes execute, child['k8s'] }
#   #     end
#   #   end
#   # end
#   #
#   # describe '#sentence_from' do
#   #   let(:call) { -> (array) { config.sentence_from(array) } }
#   #
#   #   Then { assert_equal 'one, two and three', call[%w(one two three)] }
#   #   And  { assert_equal 'one and two', call[%w(one two)] }
#   #   And  { assert_equal 'one', call[%w(one)] }
#   # end
#   #
#   # describe '#story' do
#   #   describe 'permitted keys' do
#   #     Then { assert_includes config.story.keys, :actions }
#   #     And  { assert_includes config.story.keys, :env }
#   #     And  { assert_includes config.story.keys, :preface }
#   #     And  { assert_includes config.story.keys, :questions }
#   #   end
#   #
#   #   describe 'permitted environments' do
#   #     Then  { assert_includes config.story[:env].keys, :base }
#   #     And   { assert_includes config.story[:env].keys, :development }
#   #     And   { assert_includes config.story[:env].keys, :staging }
#   #     And   { assert_includes config.story[:env].keys, :production }
#   #   end
#   # end
#   #
#   # describe '#validate_catalog' do
#   #   before { skip }
#   #   let(:folder)  { "invalid" }
#   #   let(:catalog) { "#{catalog_root}/#{folder}" }
#   #   let(:execute) { config.validate_catalog(catalog) }
#   #   let(:error)   { Roro::Catalog::Story }
#   #
#   #   context 'when catalog has no children' do
#   #     before { skip }
#   #     let(:folder)        { 'invalid/with_no_children' }
#   #     let(:error_message) { 'No story in' }
#   #     Then { assert_correct_error }
#   #   end
#   #
#   #   context 'when catalog contains files with invalid extensions' do
#   #     let(:folder) { 'invalid/with_invalid_extensions' }
#   #     let(:error_message) { 'contains invalid extensions' }
#   #
#   #     Then { assert_correct_error }
#   #   end
#   #
#   #   context 'when valid' do
#   #     let(:directory) { 'valid/roro' }
#   #
#   #     Then { assert_valid }
#   #   end
#   # end
#   #
#   # describe '#validate_story' do
#   #   before { skip }
#   #   let(:error)    { Roro::Catalog::Keys }
#   #   let(:execute)  { config.validate_story(story_file) }
#   #
#   #   describe 'must return nil when story is valid' do
#   #     let(:filename) { 'valid/valid.yml' }
#   #
#   #     Then { assert_valid }
#   #   end
#   #
#   #   describe 'must return error when file' do
#   #     before { skip }
#   #
#   #     describe 'contains unpermitted keys' do
#   #       let(:filename)      { 'invalid/unpermitted_keys.yml' }
#   #       let(:error_message) { 'key must be in'}
#   #
#   #       Then { assert_correct_error }
#   #     end
#   #
#   #     context ':env value class is' do
#   #       context 'a String' do
#   #         let(:filename)      { 'invalid/env-returns-valid.yml' }
#   #         let(:error_message) { 'class must be Hash, not String'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #
#   #       context 'an Array' do
#   #         let(:error) { Roro::Story::Keys }
#   #         let(:filename)      { 'invalid/env-returns-array_of_strings.yml' }
#   #         let(:error_message) { 'class must be Hash, not Array'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #
#   #       context 'a Hash with' do
#   #         context 'a key that returns a string' do
#   #           let(:filename)      { 'invalid/env-base-returns-valid.yml' }
#   #           let(:error_message) { 'must be Hash, not String'}
#   #
#   #           Then { assert_correct_error }
#   #         end
#   #
#   #         context 'a key that returns an array' do
#   #           let(:filename)      { 'invalid/env-base-returns-array_of_strings.yml' }
#   #           let(:error_message) { 'must be Hash, not Array'}
#   #
#   #           Then { assert_correct_error }
#   #         end
#   #
#   #         context 'unpermitted keys' do
#   #           let(:filename)      { 'invalid/env-unpermitted.yml' }
#   #           let(:error_message) { 'must be in'}
#   #
#   #           Then { assert_correct_error }
#   #         end
#   #       end
#   #     end
#   #
#   #     context ':preface value class is' do
#   #       context 'an array' do
#   #         let(:filename)      { 'invalid/preface-returns-array_of_strings.yml' }
#   #         let(:error_message) { 'class must be String, not Array'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #
#   #       context 'a hash' do
#   #         let(:filename)      { 'invalid/preface-returns-hash.yml' }
#   #         let(:error_message) { 'class must be String, not Hash'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #     end
#   #
#   #     context ':actions value class is' do
#   #       context 'a hash' do
#   #         let(:filename)      { 'invalid/actions-returns-hash.yml' }
#   #         let(:error_message) { 'class must be Array, not Hash'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #
#   #       context 'string' do
#   #         let(:filename)      { 'invalid/actions-returns-valid.yml' }
#   #         let(:error_message) { 'class must be Array, not String'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #     end
#   #
#   #     context ':questions value class is' do
#   #       context 'a hash' do
#   #         let(:filename)      { 'invalid/questions-returns-hash.yml' }
#   #         let(:error_message) { 'class must be Array, not Hash'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #
#   #       context 'string' do
#   #         let(:filename)      { 'invalid/questions-returns-valid.yml' }
#   #         let(:error_message) { 'class must be Array, not String'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #
#   #       context 'hash without correct keys' do
#   #         let(:filename)      { 'invalid/unpermitted_question_keys.yml' }
#   #         let(:error_message) { 'questions key must be in'}
#   #
#   #         Then { assert_correct_error }
#   #       end
#   #     end
#   #   end
#   # end
#   #
#   describe '#sanitize(options' do
#     context 'when key is a string' do
#       When(:options) { { 'key' => 'value' } }
#       Then { assert config.options.keys.first.is_a? Symbol }
#     end
#
#     context 'when value is a' do
#       context 'string' do
#         When(:options) { { 'key' => 'value' } }
#         Then { assert config.options.values.first.is_a? Symbol }
#       end
#
#       context 'when value is an array' do
#         When(:options) { { 'key' => [] } }
#         Then { assert config.options.values.first.is_a? Array }
#       end
#
#       context 'when value is an array of hashes' do
#         When(:options) { { 'key' => [{ 'foo' => 'bar' }] } }
#         Then { assert_equal :bar, config.options[:key][0][:foo] }
#       end
#     end
#   end
# end
