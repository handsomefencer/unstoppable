require 'test_helper'

describe Roro::Configuration::Receiver do

  Given { greenfield_rails_test_base }
  Given(:options) { nil }
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
  
  describe '.default_story' do 
    
    Given(:expected)  { 
      { rollon: 
        { rails: [
          { database: 'postgresql' },
          { ci_cd: 'circleci' },
          { kubernetes: 'postgresql' }
        ] } 
      }
    }
    
    Then { assert_equal expected, config.default_story }
  end 
  
  describe '.story_map' do 
    describe 'rollon' do 
      Given(:story_map) { [
        { rails: [
          { database: [
            { postgresql: [] },
            { mysql: [] }
          ] },
          { ci_cd: [
            { circleci: [] }
          ] },
          { kubernetes: [
            { postgresql: [
              { edge: [] }, 
              { default: [] }
            ] }
          ] }
        ]}, 
        { ruby_gem: []}
      ]}

      Then { assert_equal( story_map, config.story_map(:rollon) )}
    end
  end
end
  
