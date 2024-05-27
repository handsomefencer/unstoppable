# frozen_string_literal: true

require 'test_helper'

describe 'Roro::TestHelpers::WorkbenchHelper' do
  Given(:files) { Dir.glob("#{Dir.pwd}/**/*") }

  describe '#prepare_destination when workbench is' do
    describe 'not given must not run' do
      Then { assert_equal ENV['PWD'], Dir.pwd }
      And { refute_empty files }
    end

    describe 'given but unspecified must move to tmpf without contents' do
      Given(:workbench) { }
      Then do
        refute_equal ENV['PWD'], Dir.pwd
        assert_match /tmp/, Dir.pwd
        assert_empty files
      end
    end

    describe 'given and specified must move to tmpf with specified contents' do
      Given(:workbench) { 'crypto' }
      Then do
        refute_equal ENV['PWD'], Dir.pwd
        assert_match /tmp/, Dir.pwd
        refute_empty files
      end
    end
  end
end
