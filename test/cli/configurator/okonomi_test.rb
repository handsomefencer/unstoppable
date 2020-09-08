require "test_helper"

describe Roro::Configurator do
  
  Given { greenfield_rails_test_base }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given(:options) { nil }
  Given(:config) { Roro::Configurator.new(options) }

  
  describe 'default story' do 
    Then { assert_equal 'blah', config.default_story({stories: {}}) }
  end


  
  describe 'take_order' do
    
    Given(:questions)  { config.structure[:choices] }
    Given(:intentions) { config.structure[:intentions] }
    
    Given { config.stubs(:ask).returns('n')}
    Given { config.take_order }
    
    Then { intentions.each { |key, value| assert_equal 'n', value  } }
  end
  
  # describe ''
end