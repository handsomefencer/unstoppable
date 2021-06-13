# frozen_string_literal: true

require 'test_helper'

describe Omakase do
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }
  let(:stories) { "#{Dir.pwd}/lib/roro/mise_en_place/stories" }
  let(:shelf)   { stories }

  describe '#library' do
    let(:stories)       { omakase.library[:stories] }
    let(:ruby_stories)  { stories[:ruby][:stories] }
    let(:rails_stories) { stories[:ruby][:stories].keys }

    it 'must have keys for each story' do
      assert_includes stories.keys, :python
      assert_includes stories.keys, :ruby
      assert_includes stories.keys, :php
      assert_includes stories.keys, :node
      assert_equal stories.size, 4
    end

    it 'must have keys for each child story' do

      assert_includes ruby_stories.keys, :rails
      assert_includes ruby_stories.keys, :rubygem
      assert_equal ruby_stories.size, 2
    end
  end

  describe '#checkout_story when shelf has ' do
    context 'no story' do
      Then { assert_nil omakase.checkout_story(shelf) }
    end

    context 'a story' do
      let(:shelf) { "#{stories}/ruby/stories/rails/rails" }

      Then { assert_includes omakase.checkout_story(shelf).keys, :preface }
      And  { assert_includes omakase.checkout_story(shelf).keys, :actions }
      And  { assert_includes omakase.checkout_story(shelf).keys, :variables }
      And  { assert_includes omakase.checkout_story(shelf).keys, :questions }
    end
  end
  describe '#choose_your_adventure' do


    describe '#question' do
      Then { assert_equal omakase.question(shelf), 'Please choose from these stories:' }
    end

    describe '#get_adventures' do
      context 'when ./stories/ruby/stories/folders' do
        before { skip }
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

    describe '#choose_your_adventure' do
      let(:command) { omakase.choose_your_adventure(shelf) }

      it do
        skip
        question = 'Please choose from these mise_en_place:'
        choices = ''
        options = '{}'
        assert_asked(question, choices, options)
      end
    end
  end
end
