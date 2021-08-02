# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  let(:subject)      { Configurator }
  let(:options)      { nil }
  let(:config)       { subject.new(options) }
  let(:catalog_root) { "#{Roro::CLI.catalog_root}" }
  let(:scene)        { catalog_root }

  let(:story_file)   { "#{Dir.pwd}/test/fixtures/files/stories/#{filename}" }

  describe '#merge_story' do
    before { skip }
    Given { config.merge_story(story_file) }
    Then  { assert_includes config.story.keys, :env }
    And   { assert_includes config.story.keys, :preface }
    And   { assert_includes config.story.keys, :questions }

    describe 'preface value be a string' do
      Then { assert_equal config.story[:preface].class, String }
    end

    describe 'env value be a hash' do
      Then { assert_equal config.story[:env].class, Hash }
      And  { assert_equal config.story[:env][:base].class, Hash }
    end

    describe 'actions value must be an array of strings' do
      Then { assert_equal config.story[:actions].class, Array }
      And  { assert_equal config.story[:actions].first.class, String }
    end

    describe 'questions value must be an array of hashes' do
      Then { assert_equal config.story[:questions].class, Array }
      And  { assert_equal config.story[:questions].first.class, Hash }
    end
  end

  describe '#get_plot_preface' do
    before { skip }
    let(:preface) { config.get_plot_preface(scene) }

    context 'when scene has no plot file' do
      Then { assert_nil preface }
    end

    context 'when scene has a plot file with a preface' do
      let(:scene) { "#{catalog_root}/roro/plots/ruby" }

      Then { assert_match 'simplicity and productivity', preface }
    end
  end

  describe '#get_plot_choices' do
    before { skip }
    let(:scene) { "#{catalog_root}/roro/plots" }

    let(:plot_choices) { config.get_plot_choices(scene) }

    Then { assert_includes plot_choices.values, 'php' }
  end

  describe '#choose_your_adventure' do
    let(:question) { "Please choose from these #{collection}:" }
    let(:choices)  { plots.sort.map.with_index { |x, i| [i + 1, x] }.to_h }
    let(:prompt)   { "#{question} #{choices}" }
    let(:command) { config.choose_plot(scene) }

    def assert_plot_chosen(collection, plots, plot)
      question = "Please choose from these #{collection}:"
      choices = plots.sort.map.with_index { |x, i| [i + 1, x] }.to_h
      prompt = "#{question} #{choices}"
      assert_asked(prompt, choices, plot)
    end

    let(:acts) do
      [
        ['roro plots', %w[node php python ruby], 4],
        ['ruby plots', %w[rails ruby_gem], 1],
        ['rails plots', %w[rails rails_react rails_vue], 2]
      ]
    end

    describe '#choose_your_adventure' do
      let(:command) { config.choose_your_adventure(scene) }

      # Then do
      #   acts.each { |act| assert_plot_chosen(*act) }
      #   command
      #   assert_equal({ ruby: { rails: { rails_react: {} } } }, config.story)
      # end
    end

    describe '#choose_plot' do
      let(:command) { config.choose_plot(scene) }

      context 'from lib/roro/library/plots' do
        # Then do
        #   assert_plot_chosen(*acts[0])
        #   command
        # end
      end

      context 'ruby plots' do
        let(:scene) { "#{catalog_root}/roro/plots/ruby/plots" }

        # Then do
        #   assert_plot_chosen(*acts[1])
        #   command
        # end
      end

      context 'from lib/roro/library/plots/ruby/plots/rails/plots' do
        let(:scene) { "#{catalog_root}/plots/ruby/plots/rails/plots" }

        # Then do
        #   assert_plot_chosen(*acts[2])
        #   command
        # end
      end

      context 'from lib/roro/library/databases' do
        let(:scene)      { "#{catalog_root}/roro/plots/ruby/plots/rails/databases" }
        let(:collection) { 'rails databases' }
        let(:plots)      { %w[mysql postgres] }
        let(:choice)     { { 1 => 'mysql' } }

        # Then { assert_asked(prompt, choices, choice.keys.first) }
        # And  { assert_equal choice.values.first, command }
      end
    end
  end

  describe '#choose_env_var' do
    let(:scene)    { "#{catalog_root}/plots/ruby" }
    let(:question) { config.get_plot(scene)[:questions][0] }
    let(:command)  { config.choose_env_var(question) }
    let(:prompt)   { question[:question] }
    let(:answer)   { 'schadenfred' }

    Given do
      Thor::Shell::Basic.any_instance
                        .stubs(:ask)
                        .with(prompt)
                        .returns(answer)
    end

    Given { command }
    # Then  { assert_includes config.env[:docker_username], 'schadenfred' }
  end

  describe '#write_adventure' do
    let(:scene) { catalog_root }
    let(:story) { { roro: {} } }

    Given do
      Roro::Configurators::Omakase
        .any_instance
        .stubs(:story)
        .returns(story)
    end

    # Then { assert_equal config.story, story }
  end

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
