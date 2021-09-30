# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  let(:subject)      { Configurator }
  let(:options)      { { stack: stack_path } }
  let(:config)       { subject.new(options) }
  let(:inflections)  { [] }

  describe '#initialize' do
    context 'when options not supplied' do
      When(:options) { {} }
      Then { assert_match 'roro/catalog', config.stack }
    end

    context 'when options supplied' do
      Then { assert_match 'stack/valid', config.stack }
    end
  end

  describe '#validate_stack' do
    Then { assert config.validate_stack }
  end

  describe '#choose_adventure' do
    describe 'must set the itinerary when stack with' do
      let(:assert_adventure_chosen) {
        assert_inflections(inflections)
        config.choose_adventure }

      context 'one inflection' do
        When(:stack) { 'stack/with_one_inflection' }
        Given { inflections << %w[plots story] }
        Given { assert_adventure_chosen }
        Then  { assert_file_match_in 'plots/story', config.itinerary }
      end

      context 'multiple inflections' do
        When(:stack) { 'stack/stack' }
        Given { inflections << %w[plots story]}
        Given { inflections << %w[stories story]}
        Given { assert_adventure_chosen }
        Then  { assert_file_match_in('plots/story', config.itinerary ) }
        # And   { assert_equal 'blah', config.itinerary }
      end
    end
  end

  describe '#build_manifests' do
    When(:stack) { 'stack/with_one_inflection' }
    Given { inflections << %w[plots story] }

    Given { assert_adventure_chosen }
    Given { config.build_manifest }
    # Then  { assert_file_match_in('fatsufodo.yml', config.manifest) }
    # And   { assert_file_match_in('django.yml', config.manifest) }
  end

  describe '#build_actions' do
    Given { assert_adventure_chosen }
    Given { config.build_manifest }

    describe 'actions variable' do
      let(:actions) { config.actions }

      describe 'must be set' do
        Given { config.build_actions }
        # Then  { assert_equal Array, actions.class }
      end
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
