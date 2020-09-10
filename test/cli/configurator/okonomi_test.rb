require "test_helper"

describe Roro::Configurator do
    
  Given { greenfield_rails_test_base }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given(:options) { nil }
  Given(:config) { Roro::Configurator.new(options) }

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
    
    Then { assert_equal expected, config.golden }
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

  describe 'take_order' do

    Given(:questions)  { config.structure[:choices] }
    Given(:intentions) { config.structure[:intentions] }

    Given { config.stubs(:ask).returns('n')}
    Given { config.take_order }

    Then { intentions.each { |key, value| assert_equal 'n', value  } }
  end
end