# frozen_string_literal: true

require 'test_helper'

describe Omakase do
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }
  let(:plot_root) { "#{Dir.pwd}/lib/roro/stories" }
  let(:scene) { "#{plot_root}/plots" }

  describe '#get_plot' do
    let(:plot) { omakase.get_plot(scene) }

    context 'when scene has' do
      context 'no plot file' do
        Then { assert_nil plot }
      end

      context 'a plot file' do
        let(:scene) { "#{plot_root}/plots/ruby" }

        describe 'must return a hash' do
          Then { assert_equal plot.class, Hash }
        end

        describe 'keys' do
          Then { assert_includes plot.keys, :env }
          And  { assert_includes plot.keys, :preface }
          And  { assert_includes plot.keys, :questions }
        end

        describe 'questions' do
          Then { assert_equal plot[:questions][0][:question], 'Please supply your docker username' }
          And  { assert_equal plot[:questions][0][:help], 'https://hub.docker.com/signup' }
          And  { assert_equal plot[:questions][0][:action], 'config.env[:docker_username]=answer' }
          And  { assert_equal plot[:env][:ruby], 2.7 }
        end
      end
    end
  end

  describe '#get_plot_preface' do
    let(:preface) { omakase.get_plot_preface(scene) }

    context 'when scene has no plot file' do
      Then { assert_nil preface }
    end

    context 'when scene has a plot file with a preface' do
      let(:scene) { "#{plot_root}/plots/ruby" }

      Then { assert_match 'simplicity and productivity', preface }
    end

    context 'when scene has a plot file with no preface' do
      let(:scene) { "#{plot_root}/plots/php" }

      Then { assert_nil preface }
    end
  end

  describe '#get_plot_choices' do
    let(:plot_choices) { omakase.get_plot_choices(scene) }

    Then { assert_includes plot_choices.values, 'php' }
  end

  describe '#choose_your_adventure' do
    let(:question) { "Please choose from these #{collection}:" }
    let(:choices)  { plots.sort.map.with_index { |x, i| [i + 1, x] }.to_h }
    let(:prompt)   { "#{question} #{choices}" }
    let(:command) { omakase.choose_plot(scene) }

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
      let(:command) { omakase.choose_your_adventure(scene) }

      Then do
        acts.each { |act| assert_plot_chosen(*act)}
        command
        assert_equal({ ruby: { rails: { rails_react: {} } } }, omakase.story)
      end
    end

    describe '#choose_plot' do
      let(:command) { omakase.choose_plot(scene) }

      context 'from lib/roro/stories/plots' do
        Then do
          assert_plot_chosen(*acts[0])
          command
        end
      end

      context 'from lib/roro/stories/plots/ruby/plots' do
        let(:scene) { "#{plot_root}/plots/ruby/plots" }

        Then do
          assert_plot_chosen(*acts[1])
          command
        end
      end

      context 'from lib/roro/stories/plots/ruby/plots/rails/plots' do
        let(:scene) { "#{plot_root}/plots/ruby/plots/rails/plots" }

        Then do
          assert_plot_chosen(*acts[2])
          command
        end
      end

      context 'from lib/roro/stories/databases' do
        let(:scene)      { "#{plot_root}/databases" }
        let(:collection) { 'roro databases' }
        let(:plots)      { %w[mysql postgres] }
        let(:choice)     { { 1 => 'mysql' } }

        Then { assert_asked(prompt, choices, choice.keys.first) }
        And  { assert_equal choice.values.first, command }
      end
    end
  end
end
