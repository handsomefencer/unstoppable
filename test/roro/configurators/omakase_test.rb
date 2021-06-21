# frozen_string_literal: true

require 'test_helper'

describe Omakase do
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }
  let(:plot_root) { "#{Dir.pwd}/lib/roro/plots" }
  let(:scene) { "#{plot_root}/plots" }

  describe '#get_plot' do
    let(:plot) { omakase.get_plot(scene) }

    context 'when scene has' do
      context 'no plot file' do
        Then { assert_nil plot }
      end

      context 'a plot file' do
        let(:scene) { "#{plot_root}/plots/ruby" }

        Then { assert_equal plot.class, Hash }
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
      context 'from lib/roro/plots/plots' do
        let(:command) { omakase.choose_plot(scene) }

        Then do
          assert_plot_chosen(*acts[0])
          command
        end
      end

      context 'from lib/roro/plots/plots' do
        let(:collection) { 'roro plots' }
        let(:plots)      { %w[node php python ruby] }
        let(:plot)       { 4 }

        context '#choose_plot' do
          let(:command) { omakase.choose_plot(scene) }

          Then { assert_asked(prompt, choices, plot) }
          And  { assert_equal 'ruby', command }
        end

        # context '#choose_your_adventure' do
        #   let(:command) { omakase.choose_your_adventure(scene) }
        #
        #   Then { assert_adventure_chosen(prompt, choices, plot) }
        #   # And { assert_equal omakase.story, 'blah'}
        #   # And  { assert_equal 'node', command }
        # end
      end

      context 'from lib/roro/plots/plots/ruby/plots' do
        let(:scene)      { "#{plot_root}/plots/ruby/plots" }
        let(:collection) { 'ruby plots' }
        let(:plots)      { %w[rails ruby_gem] }

        Then { assert_asked(prompt, choices, 2) }
        And  { assert_equal 'ruby_gem', command }
      end

      context 'from lib/roro/plots/plots/ruby/plots/rails/plots' do
        let(:scene)      { "#{plot_root}/plots/ruby/plots/rails/plots" }
        let(:collection) { 'rails plots' }
        let(:plots)      { %w[rails rails_react rails_vue] }

        Then { assert_asked(prompt, choices, 2) }
        And  { assert_equal 'rails_react', command }
      end

      context 'from lib/roro/plots/databases' do
        let(:scene)      { "#{plot_root}/databases" }
        let(:collection) { 'roro databases' }
        let(:plots)      { %w[mysql postgres] }
        let(:choice)     { { 1 => 'mysql' } }

        Then { assert_asked(prompt, choices, choice.keys.first) }
        And  { assert_equal choice.values.first, command }
      end
    end
  end

  describe '#question' do
    context 'when scene has no plot' do
      let(:scene) { "#{Dir.pwd}/lib/roro/plots" }

      Then { assert_equal omakase.question(scene), 'Please choose from these plots:' }
    end

    context 'when scene has a plot' do
      before { skip }
      let(:scene) { "#{Dir.pwd}/lib/roro/plots/ruby" }

      Then { assert_equal omakase.question(scene), 'Please choose from these plots:' }
    end
  end

  describe '#choose_your_adventure' do
    # before { skip }
    # let(:scene) { "#{Dir.pwd}/lib/roro" }
    # context 'when starting' do
    #   let(:begin_adventure) { omakase.choose_your_adventure(scene) }
    #
    #   # Then { assert_equal %w[django rails], adventures }
    # end

    # describe '#get_adventures' do
    #   context 'when ./plots/ruby/plots/folders' do
    #     before { skip }
    #     let(:adventures) { omakase.get_adventures(shelf).values }
    #
    #     Then { assert_equal %w[django rails], adventures }
    #   end
    # end
  end
end
