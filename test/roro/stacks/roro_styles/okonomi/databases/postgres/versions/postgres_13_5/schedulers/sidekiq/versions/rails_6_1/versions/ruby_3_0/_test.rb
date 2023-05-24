# frozen_string_literal: true

require 'test_helper'

describe 'roro_styles: okonomi & databases: postgres & versions: postgres_13_5 & schedulers: sidekiq & versions: rails_6_1 & versions: ruby_3_0' do
  Given(:workbench) {}
  
  Given do 
    skip
    @rollon_dummies = false 
    rollon(__dir__) 
  end
  
  describe 'must have directory' do
    Given(:directory) { 'expected/directory' }
    Then { assert_directory directory }
    
    describe 'with file' do 
      Given(:file) { "#{directory}/expected/file.name" }

      Then { assert_file file }

      describe 'with content' do 
        Given(:content) { /expected content string/ }

        Then { assert_file file, content }
      end 
    end
  end 
end
