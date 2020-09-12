require 'test_helper'

describe Roro::Configuration::Receiver do

  Given { greenfield_rails_test_base }
  
  Given(:config) { Roro::Configuration.new(options) }

  describe 'sanitizing options when options contain' do
    
    Given(:expected) { { story: { rails: {} } } }
    Given(:actual) { config.sanitize(options) }
    
    describe 'nested hashes' do 
        
      Given(:options) { expected }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'nil' do 
        
      Given(:expected) { {} }
      Given(:options) { nil }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'symbols' do

      Given(:options) { { story: :rails } }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'strings' do

      Given(:options) { { 'story' =>  'rails' } }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'booleans' do

      Given(:options) { { story: { rails: true } } }
      
      Then { assert_equal expected, actual }
    end
    
    describe 'contains arrays' do 

      Given(:expected) { { story: { rails: [
        { database: { postgresql: {} }},
        { ci_cd:    { circleci:   {} }}
      ] } } }

      Given(:options) { { story: { rails: [
        { database: { 'postgresql' => {} }},
        { ci_cd:    { circleci:   {} }}
      ] } } }
      
      Given(:expected)  { options }
   
      Then { assert_equal expected, actual } 
    end
  end 
end
  
