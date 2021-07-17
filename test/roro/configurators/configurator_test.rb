# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  let(:subject)      { Configurator }
  let(:options)      { nil }
  let(:config)       { subject.new(options) }
  let(:catalog_root) { "#{Roro::CLI.catalog_root}" }
  let(:scene)        { catalog_root }

  describe '#get_plot' do
    before { skip }

    let(:plot) { config.get_plot(scene) }

    context 'when scene has' do
      context 'no plot file' do
        Then { assert_nil plot }
      end

      context 'a plot file' do
        before { skip }
        let(:scene) { "#{catalog_root}/roro" }

        describe 'must return a hash with desired keys' do
          Then { assert_equal plot.class, Hash }
          And  { assert_includes plot.keys, :env }
          And  { assert_includes plot.keys, :preface }
          And  { assert_includes plot.keys, :questions }
        end

        describe 'questions' do
          Then { assert_equal plot[:questions][0][:question], 'Please supply the name of your project' }
          And  { assert_equal plot[:questions][0][:help], 'https://github.com/schadenfred/roro/wiki' }
        end

        describe 'env' do
          # Then { assert_equal plot[:env][:roro_version], '2.7' }
        end
      end
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

      context 'from lib/roro/stories/plots' do
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

      context 'from lib/roro/stories/plots/ruby/plots/rails/plots' do
        let(:scene) { "#{catalog_root}/plots/ruby/plots/rails/plots" }

        # Then do
        #   assert_plot_chosen(*acts[2])
        #   command
        # end
      end

      context 'from lib/roro/stories/databases' do
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
