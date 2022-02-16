# # frozen_string_literal: true
#
# require 'test_helper'
#
# describe 'Roro::CLI#generate_adventure_describes' do
#   Given(:subject)        { Roro::CLI.new }
#   Given(:workbench)      { 'test_annotate/lib' }
#   Given(:base)           { 'lib/roro/stacks/unstoppable_developer_styles' }
#   Given(:space)          { "#{base}/okonomi/languages/ruby/frameworks/rails" }
#   Given(:story_path)     { "#{space}/versions/v6_1" }
#   Given(:description)    { 'adventure::rails-v6_1::0 sqlite & ruby-v2_7' }
#   Given(:expected)       { /describe 'adventure::rails-v6_1::0 sqlite & ruby-v2_7'/ }
#   Given(:adventure_test) { "#{story_path}/test/0/_test.rb" }
#   Given(:dummy)          { "#{story_path}/test/0/dummy/idiot.yaml" }
#
#   Given { subject.generate_adventure_test_describes }
#
#   describe '#description_helper(adventure_test)' do
#     Given(:result) { subject.description_helper(adventure_test) }
#     focus
#     Then { assert_match (/idiot\.yamddl/), result }
#   end
#
#   describe '#dummies_for(adventure_test) when dummies' do
#     Given(:result) { subject.dummies_for(adventure_test) }
#
#     context 'present' do
#       Then { assert_includes result, 'idiot.yaml' }
#     end
#
#     context 'not present' do
#       Given(:story_path) { "#{space}/versions/v7_0" }
#       Then { assert_includes result, 'README.md' }
#     end
#
#     context 'nested' do
#       Then { assert_includes result, 'nested/idiot.yaml' }
#     end
#   end
#
#   describe '#dummy_path_for(adventure_test)' do
#     Given(:result) { subject.dummy_path_for(adventure_test) }
#     Then { assert_match 'test/0/dummy', result }
#     And  { refute_match 'test/dummy/', result }
#   end
#
#   describe '#story_path_for(adventure_test)' do
#     Given(:result) { subject.story_path_for(adventure_test) }
#     Then { assert_match "versions/v6_1", result }
#     And  { refute_match "versions/v6_1/", result }
#   end
#
#   describe '#adventure_test_files' do
#     Then { assert_includes subject.adventure_test_files, adventure_test }
#   end
# end
