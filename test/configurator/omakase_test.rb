require 'test_helper'

describe Roro::Configurator::Omakase do
  
  Given { greenfield_rails_test_base }
  Given(:options)    { nil }
  Given(:config)     { Roro::Configuration.new(options) }
  
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
  
  describe '.story_map for' do 
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