# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  let(:subject)      { Configurator }
  let(:options)      { { catalog: catalog.nil? ? catalog_root : catalog_path } }
  let(:config)       { subject.new(options) }
  let(:catalog_root) { "#{Roro::CLI.catalog_root}" }
  let(:catalog_path) { catalog_root }
  let(:catalog)      { nil }
  let(:inflections)  { [] }

  describe '#validate_catalog' do
    context 'when invalid' do
      let(:error)         { Roro::Error }
      let(:error_message) { 'Catalog cannot be an empty folder' }
      let(:catalog_root)  { "#{Dir.pwd}/test/fixtures/catalogs/structure" }
      let(:catalog)       { 'empty' }
      let(:execute)       { config }
      let(:options)       { { catalog: catalog_path } }

      Then  { assert_correct_error }
    end
  end

  let(:fatsufodo_django) { [
    %w[use_cases 1],
    %w[use_cases/fatsufodo/stories 1]
  ]}
  describe '#choose_adventure' do
    let(:itinerary) { config.itinerary }
    Given { assert_inflections(fatsufodo_django) }

    context 'use_cases/fatsufodo/stories/django' do
      Then  { assert_file_match_in('fatsufodo/stories/django', itinerary) }
    end
  end

  # describe '#merge_story' do
  #   before { skip }
  #   Given { config.merge_story(story_file) }
  #   Then  { assert_includes config.story.keys, :env }
  #   And   { assert_includes config.story.keys, :preface }
  #   And   { assert_includes config.story.keys, :questions }
  #
  #   describe 'preface value be a string' do
  #     Then { assert_equal config.story[:preface].class, String }
  #   end
  #
  #   describe 'env value be a hash' do
  #     Then { assert_equal config.story[:env].class, Hash }
  #     And  { assert_equal config.story[:env][:base].class, Hash }
  #   end
  #
  #   describe 'actions value must be an array of strings' do
  #     Then { assert_equal config.story[:actions].class, Array }
  #     And  { assert_equal config.story[:actions].first.class, String }
  #   end
  #
  #   describe 'questions value must be an array of hashes' do
  #     Then { assert_equal config.story[:questions].class, Array }
  #     And  { assert_equal config.story[:questions].first.class, Hash }
  #   end
  # end
  #
  # describe '#choose_env_var' do
  #   let(:scene)    { "#{catalog_root}/plots/ruby" }
  #   let(:question) { config.get_plot(scene)[:questions][0] }
  #   let(:command)  { config.choose_env_var(question) }
  #   let(:prompt)   { question[:question] }
  #   let(:answer)   { 'schadenfred' }
  #
  #   Given do
  #     Thor::Shell::Basic.any_instance
  #                       .stubs(:ask)
  #                       .with(prompt)
  #                       .returns(answer)
  #   end
  #
  #   Given { command }
  #   # Then  { assert_includes config.env[:docker_username], 'schadenfred' }
  # end
  #
  # describe '#write_adventure' do
  #   let(:scene) { catalog_root }
  #   let(:story) { { roro: {} } }
  #
  #   Given do
  #     Roro::Configurators::Omakase
  #       .any_instance
  #       .stubs(:story)
  #       .returns(story)
  #   end
  #
  #   # Then { assert_equal config.story, story }
  # end
  #
  # describe '#sanitize(options' do
  #   context 'when key is a string' do
  #     When(:options) { { 'key' => 'value' } }
  #     Then { assert config.options.keys.first.is_a? Symbol }
  #   end
  #
  #   context 'when value is a' do
  #     context 'string' do
  #       When(:options) { { 'key' => 'value' } }
  #       Then { assert config.options.values.first.is_a? Symbol }
  #     end
  #
  #     context 'when value is an array' do
  #       When(:options) { { 'key' => [] } }
  #       Then { assert config.options.values.first.is_a? Array }
  #     end
  #
  #     context 'when value is an array of hashes' do
  #       When(:options) { { 'key' => [{ 'foo' => 'bar' }] } }
  #       Then { assert_equal :bar, config.options[:key][0][:foo] }
  #     end
  #   end
  # end
end
