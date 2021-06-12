# frozen_string_literal: true

require 'test_helper'

describe Omakase do
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }

  describe '#library' do
    let(:entrees) { omakase.library.keys }
    let(:rails)   { omakase.library[:rails].keys }

    it 'must have keys for each entree' do
      assert_includes entrees, :rails
      assert_includes entrees, :django
    end

    it 'must have keys' do
      assert_includes rails, :rails
      assert_includes rails, :database
    end
  end

  describe '#choose_your_adventure' do
    Given(:shelf) { "#{Dir.pwd}/lib/roro/stories/entrees" }

    describe '#checkout_story' do
      context 'when no story on shelf' do
        Then { assert_nil omakase.checkout_story(shelf) }
      end
    end

    describe '#question' do
      Then { assert_equal omakase.question(shelf), 'Please choose from these entrees:' }
    end

    describe '#get_adventures' do
      context 'when shelf has django and rails folders' do
        let(:adventures) { omakase.get_adventures(shelf).values }

        Then { assert_equal %w[django rails], adventures }
      end
    end

    describe '#get_preface' do
      context 'when no preface in story yml' do
        let(:preface) { omakase.get_preface(shelf) }

        Then { assert_nil preface }
      end

      context 'when preface in story yml' do
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

    describe '#choose_your_adventure' do
      let(:command) { omakase.choose_your_adventure(shelf) }

      it do
        skip
        question = 'Please choose from these entrees:'
        choices = ''
        options = '{}'
        assert_asked(question, choices, options)
      end
    end
  end
end
