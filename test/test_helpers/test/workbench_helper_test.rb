# frozen_string_literal: true

require 'test_helper'

describe 'Roro::TestHelpers::WorkbencHelper' do
  Given(:files) { Dir.glob("#{Dir.pwd}/**/*") }

  describe '#prepare_destination when workbench is' do
    describe 'unspecified must not run' do
      Then { assert_equal ENV['PWD'], Dir.pwd }
      And { refute_empty files }
    end

    describe 'specified but nil must move to empty tmp folder' do
      Given(:workbench) { }
      Then do
        refute_equal ENV['PWD'], Dir.pwd
        assert_match /tmp/, Dir.pwd
        assert_empty files
      end
    end

    describe 'specified with dummy folder moves to tmp folder with dummies' do
      Given(:workbench) { 'crypto' }
      Then do
        refute_equal ENV['PWD'], Dir.pwd
        assert_match /tmp/, Dir.pwd
        refute_empty files
      end
    end
  end
end
