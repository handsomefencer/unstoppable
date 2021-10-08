# # frozen_string_literal: true
#
# require 'test_helper'
# require 'stringio'
#
# describe 'AskInflection' do
#   let(:asker)    { AskInflection.new }
#   let(:env_hash) { read_yaml(stack_path)[:env] }
#   let(:stack)    { 'story/story.yml'}
#   let(:options)  { { storyfile: stack_path } }
#
#   describe '#build_inflection' do
#     let(:humanized)          { asker.humanize(asker.inflection_options) }
#     let(:inflection_options) { asker.inflection_options }
#     let(:inflection_prompt)  { asker.inflection_prompt }
#     let(:preface)            { asker.get_story_preface(stack_path) }
#     let(:question)           { asker.build_inflection }
#     let(:story_from)         { asker.story_from('1') }
#     let(:stack)              { 'stacks' }
#
#     describe '#inflection_prompt' do
#       context 'when stacks' do
#         When(:stack)    { 'stacks' }
#         When(:expected) { 'Please choose from these valid stacks:' }
#         Then { assert_includes inflection_prompt, expected }
#       end
#
#       context 'when stack/stacks' do
#         When(:stack) { 'stack/stacks' }
#         Then { assert_includes inflection_prompt, 'these stack stacks' }
#       end
#
#       context 'when stack parent is rails and inflection is flavors' do
#         When(:stack) { 'stack/stack/inflection/stack/inflection/rails/flavors' }
#         Then { assert_includes inflection_prompt, 'these rails flavors' }
#       end
#     end
#
#     describe '#inflection_options' do
#       Then { assert_equal inflection_options.size, 2 }
#       And  { assert_includes inflection_options.values, 'story' }
#       And  { assert_includes inflection_options.values, 'story2' }
#
#       context 'when stack/stack/plots' do
#         When(:stack) { 'stack/stack/plots' }
#         Then { assert_equal 2, inflection_options.count }
#         And  { assert_equal String, inflection_options.keys.first.class }
#       end
#     end
#
#     describe '#get_story_preface' do
#       context 'when story' do
#         context 'has a preface' do
#           When(:stack) { 'story' }
#           Then { assert_match 'some string', preface }
#         end
#
#         context 'has a preface and is nested' do
#           When(:stack) { 'stacks/story' }
#           Then { assert_match 'some string', preface }
#         end
#
#         context 'has no preface' do
#           When(:stack) { 'stack/stack/stories/story' }
#           Then { assert_nil preface }
#         end
#       end
#     end
#
#     describe '#humanize_options(hash)' do
#       context 'when two stories' do
#         Then { assert humanized.is_a?(String) }
#         And  { assert_match '(1) story:', humanized}
#         And  { assert_match '(2) story2:', humanized}
#       end
#     end
#
#     describe '#question' do
#       Then { assert_equal Array, question.class }
#       And  { assert_equal Hash, question.last.class }
#       And  { assert_equal Array, question.last[:limited_to].class }
#       And  { assert_match inflection_prompt, question.first }
#     end
#
#     describe '#story_from(key, hash)' do
#       Then { assert_equal 'story', story_from }
#
#       context 'when /stack/stacks' do
#         When(:stack) { 'stack/stacks' }
#         Then { assert_equal 'stacks_1', story_from }
#       end
#     end
#   end
# end
