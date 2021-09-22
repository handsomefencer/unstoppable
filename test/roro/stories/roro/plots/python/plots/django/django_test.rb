# # frozen_string_literal: true
#
# require 'test_helper'
#
# describe 'Stories: Roro' do
#   let(:workbench) { nil }
#   # let(:options)   { nil }
#   let(:subject)   { Roro::Configurators::Configurator }
#   let(:cli)       { Roro::CLI.new }
#   # let(:config)    { subject.new(options) }
#   let(:catalog)   { "#{Roro::CLI.catalog_root}" }
#   let(:command)   { cli.roll_your_own }
#   let(:acts) do
#     [
#       ['roro plots', %w[node php python ruby], 3],
#       ['python plots', %w[django flask], 1]
#       # ['rails plots', %w[rails rails_react rails_vue], 2]
#     ]
#   end
#
#   describe '#roll_your_own' do
#     let(:command) { cli.roll_your_own }
#
#     Then do
#       skip
#       acts.each { |act| assert_story_rolled(*act) }
#       command
#       assert_includes cli.story[:variables].keys, :roro_version
#     end
#
#     # And { assert_file 'blah' }
#   end
#
#   describe '#choose_plot' do
#     let(:command) { config.choose_plot(scene) }
#
#     context 'from lib/roro/library/plots' do
#       # Then do
#       #   assert_plot_chosen(*acts[0])
#       #   command
#       # end
#     end
#
#     context 'ruby plots' do
#       let(:scene) { "#{catalog_root}/roro/plots/ruby/plots" }
#
#       # Then do
#       #   assert_plot_chosen(*acts[1])
#       #   command
#       # end
#     end
#
#     context 'from lib/roro/library/plots/ruby/plots/rails/plots' do
#       let(:scene) { "#{catalog_root}/plots/ruby/plots/rails/plots" }
#
#       # Then do
#       #   assert_plot_chosen(*acts[2])
#       #   command
#       # end
#     end
#
#     context 'from lib/roro/library/databases' do
#       let(:scene)      { "#{catalog_root}/roro/plots/ruby/plots/rails/databases" }
#       let(:collection) { 'rails databases' }
#       let(:plots)      { %w[mysql postgres] }
#       let(:choice)     { { 1 => 'mysql' } }
#
#       # Then { assert_asked(prompt, choices, choice.keys.first) }
#       # And  { assert_equal choice.values.first, command }
#   # Given { command }
#   # Then  { assert_file 'roro/env/.keep' }
#   # And   { assert_file 'roro/containers/.keep' }
#   # And   { assert_file 'roro/keys/.keep' }
#   # And   { assert_file 'roro/scripts/.keep' }
#     end
#   end
#
# end
