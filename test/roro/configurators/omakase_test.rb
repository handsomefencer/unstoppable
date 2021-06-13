# frozen_string_literal: true

require 'test_helper'

describe Omakase do
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }
  let(:plot_root) { "#{Dir.pwd}/lib/roro/plots" }

  describe '#choose_your_own_adventure do' do
    describe '#choose_plot' do
      describe '#get_plot_choices' do
        describe '#get_plot_preface' do
          context 'when no plot file' do
            let(:scene)   { plot_root + '/plots/node' }
            let(:preface) { omakase.get_plot_preface(scene) }

            Then { assert_nil preface }
          end

          context 'when plot file has no preface' do
            let(:scene)   { plot_root + '/plots/php' }
            let(:preface) { omakase.get_plot_preface(scene) }

            Then { assert_nil preface }

          end

          context 'when plot file contains a premise' do
            let(:scene) { plot_root + '/plots/ruby'}
            let(:preface) { omakase.get_plot_preface(scene) }

            Then { assert_match 'elegant syntax that is natural', preface }
          end
        end
      end
    end

    context 'when no preface in story yml' do
      let(:preface) { omakase.get_preface(shelf) }

      # Then { assert_nil preface }
    end

    context 'when preface in story yml' do
      before { skip }
      context 'when rails' do
        let(:preface) { omakase.get_preface(shelf + '/rails/rails')}

        Then { assert_match 'web framework optimized', preface }
      end

      context 'when django' do
        let(:preface) { omakase.get_preface(shelf + '/django/django')}

        Then { assert_match 'Python Web framework', preface }
      end
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

  describe '#checkout_plot' do
    context 'when scene has no plot file with .yml extension' do
      let(:scene) { "#{Dir.pwd}/lib/roro/plots/plots/node" }

      Then { assert_nil omakase.checkout_plot(scene) }
    end

    context 'when scene has a plot file with .yml extension' do
      let(:scene) { "#{Dir.pwd}/lib/roro/plots/plots/ruby/plots/rails/rails" }

      Then { assert_includes omakase.checkout_plot(scene).keys, :preface }
      And  { assert_includes omakase.checkout_plot(scene).keys, :actions }
      And  { assert_includes omakase.checkout_plot(scene).keys, :variables }
      And  { assert_includes omakase.checkout_plot(scene).keys, :questions }
    end
  end

  describe '#get_plot_choices' do
    let(:scene) { plot_root + '/plots' }
    let(:plot_choices) { omakase.get_plot_choices(scene) }

    Then { assert_equal %w[ruby php node python ], plot_choices.values }
  end

  describe '#choose_plot' do
    let(:scene) { plot_root + '/plots' }

    # Then { assert_equal omakase.pick_plot(scene), 'Please choose from these roro plots:' }
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
