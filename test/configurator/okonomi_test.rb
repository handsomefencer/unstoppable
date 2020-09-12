require "test_helper"

describe Roro::Configuration do
    
  Given { greenfield_rails_test_base }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given(:options) { nil }
  Given(:config) { Roro::Configuration.new(options) }

  describe 'not recognized' do 
    
    Given(:options) { { story: :nostory} }
  
    Then  { assert_raises(  Roro::Error  ) { config } }
  end
  
  describe 'take_order' do

    Given(:questions)  { config.structure[:choices] }
    Given(:intentions) { config.structure[:intentions] }

    Given { config.stubs(:ask).returns('n')}
    Given { config.take_order }

    Then { intentions.each { |key, value| assert_equal 'n', value  } }
  end
end