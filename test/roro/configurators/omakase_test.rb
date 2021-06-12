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

  describe '#checkout_story' do
    context 'when no story on shelf' do
      Given(:shelf) { "#{Dir.pwd}/lib/roro/stories/entrees" }
      Then { assert_nil omakase.checkout_story(shelf) }
    end
  end

  describe '#choose_your_adventure' do
    Given(:shelf) { "#{Dir.pwd}/lib/roro/stories/entrees" }
    Then { assert_equal omakase.choose_your_adventure(shelf), %w[django rails] }
  end

  describe '#question' do
    Given(:shelf) { "#{Dir.pwd}/lib/roro/stories/entrees" }
    Then { assert_equal omakase.question(shelf), 'Please choose from these entrees' }
  end

  describe '#choices' do
    Given(:shelf) { "#{Dir.pwd}/lib/roro/stories/entrees" }
    Then { assert_equal omakase.choices(shelf), %w[django rails] }
  end

  describe '#ask_question' do
    Given(:shelf) { "#{Dir.pwd}/lib/roro/stories/entrees" }

    # Then { assert_equal 'n', omakase.ask_question(shelf) }
    let(:output) { capture_io { omakase.ask_question(shelf) } }

    it do
      assert_equal output, 'blah'
    end

  end





end
