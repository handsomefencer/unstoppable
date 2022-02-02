# frozen_string_literal: true

require 'test_helper'

describe 'adventure::django::0 python-v3_10_1' do
  Given(:workbench) { }

  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }
  
  describe 'directory must contain' do
    describe 'README.md' do
      Given(:file) { 'README.md' }
      Then { assert_file file }
  
      describe 'must have content' do 
        describe 'equal to' do 
          Then { assert_file file, 'foo' }
        end

        describe 'matching' do 
          Then { assert_file file, /foo/ }
          Then { assert_content file, /foo/ }
        end
      end
    end
  end


  describe 'other sting' do
  end
end
