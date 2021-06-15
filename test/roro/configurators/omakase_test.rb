# frozen_string_literal: true

require 'test_helper'

describe Omakase do
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }
  let(:plot_root) { "#{Dir.pwd}/lib/roro/plots" }
  let(:scene) { "#{plot_root}/plots" }

  describe '#choose_your_own_adventure' do
    describe '#choose_plot' do
      describe '#get_plot_choices' do
        describe '#get_plot_preface' do
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

          let(:preface) { omakase.get_plot_preface(scene) }

          context 'when scene has' do
            context 'no plot file' do
              Then { assert_nil preface }
            end

            context 'a plot file with' do
              context 'a preface' do
                let(:scene) { "#{plot_root}/plots/ruby" }

                Then { assert_match 'simplicity and productivity', preface }
              end

              context 'no preface' do
                let(:scene) { "#{plot_root}/plots/php" }

                Then { assert_nil preface }
              end
            end
          end
        end

        let(:plot_choices) { omakase.get_plot_choices(scene) }

        Then { assert_includes plot_choices.values, 'php' }
      end

      describe '#choose_plot' do
        let(:scene)    { "#{plot_root}" }
        let(:command)  { omakase.choose_plot(scene) }
        let(:question) { 'Please choose from these roro plots:' }
        let(:choices)  { 'getsome ' }

        Then { assert_asked("Please choose from these roro plots: {1=>\"plots\", 2=>\"databases\"} [1, 2] ") }
      end

      # describe '#choose_plot' do
      #   before { skip }
      #   # let(:scene) { plot_root }
      #   let(:scene) { "#{Dir.pwd}/lib/roro/plots" }
      #
      #   # Dir.pwdRoro::CLI.plot_root }
      #   let(:command) { omakase.choose_plot(scene) }
      #   let(:prompt) { 'Please choose from these roro plots:' }
      #   let(:choices) { ''}
      #   let(:options) { {} }
      #
      #   Then { assert_asked(prompt, choices, options) }
      # end

    end
  end

  describe '#plot_bank' do
    before { skip }
    describe 'must return a hash with keys for each folder' do
      let(:plots) { omakase.plot_bank }

      Then { assert_includes plots.keys, :ruby }
      And  { assert_includes plots.keys, :python }

      describe 'and each nested folder' do
        let(:plots) { omakase.plot_bank[:ruby][:plots] }

        Then { assert_includes plots.keys, :rails }
        And  { assert_includes plots.keys, :ruby_gem }

        describe 'and each deeply nested folder' do
          let(:plots) { omakase.plot_bank[:ruby][:plots][:rails][:plots] }

          Then { assert_includes plots.keys, :rails }
          And  { assert_includes plots.keys, :rails_react }
          And  { assert_includes plots.keys, :rails_vue }
        end
      end
    end
  end


  describe '#get_plot' do
    context 'when scene has no plot file with .yml extension' do
      let(:scene) { "#{Dir.pwd}/lib/roro/plots/plots/node" }

      Then { assert_nil omakase.get_plot(scene) }
    end

    context 'when scene has a plot file with .yml extension' do
      let(:scene) { "#{Dir.pwd}/lib/roro/plots/plots/ruby/plots/rails/rails" }

      Then { assert_includes omakase.get_plot(scene).keys, :preface }
      And  { assert_includes omakase.get_plot(scene).keys, :actions }
      And  { assert_includes omakase.get_plot(scene).keys, :variables }
      And  { assert_includes omakase.get_plot(scene).keys, :questions }
    end
  end

  describe '#get_plot_choices' do
    let(:scene) { "#{plot_root}/plots" }
    let(:plot_choices) { omakase.get_plot_choices(scene) }

    Then { assert_includes plot_choices.values, 'ruby' }
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
