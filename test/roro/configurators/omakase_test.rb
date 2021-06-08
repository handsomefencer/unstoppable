# frozen_string_literal: true

require 'test_helper'

describe Omakase do
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }

  describe '#junbi' do
    it 'must return a hash' do
      assert omakase.junbi.is_a? Hash
    end

    describe 'junbi' do
      let(:entrees) { omakase.junbi.keys }
      let(:rails) { omakase.junbi[:rails].keys }

      it 'must have keys for each entree' do
        assert_includes entrees, :rails
        assert_includes entrees, :django
      end

      it 'must have keys' do
        assert_includes rails, :rails
        assert_includes rails, :database
      end
    end
  end

  describe '#choose_your_adventure' do

  end
end
