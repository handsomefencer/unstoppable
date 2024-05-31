
require 'test_helper'

describe 'adventure::rails-v6_1::0 sqlite & ruby-v2_7' do
  Given(:workbench) { }

  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }

  describe 'directory must contain' do
    describe 'idiot.yaml' do
      Given(:file) { 'idiot.yaml' }
      Then { assert_file file }

      describe 'must have content' do
        describe 'equal to' do
          Then { assert_content file, 'foo' }
        end

        describe 'matching' do
          Then { assert_content file, /foo/ }
          Then { assert_content file, /foo/ }
        end
      end
    end

    describe 'nested/idiot.yaml' do
      Given(:file) { 'nested/idiot.yaml' }
      Then { assert_file file }

      describe 'must have content' do
        describe 'equal to' do
          Then { assert_content file, 'foo' }
        end

        describe 'matching' do
          Then { assert_content file, /foo/ }
          Then { assert_content file, /foo/ }
        end
      end
    end

    describe 'smart.rb' do
      Given(:file) { 'smart.rb' }
      Then { assert_file file }

      describe 'must have content' do
        describe 'equal to' do
          Then { assert_content file, 'foo' }
        end

        describe 'matching' do
          Then { assert_content file, /foo/ }
          Then { assert_content file, /foo/ }
        end
      end
    end
  end
