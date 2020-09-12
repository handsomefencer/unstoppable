require "test_helper"

describe Roro::Configuration::Okonomi do

  Given { greenfield_rails_test_base }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given(:options) { nil }
  Given(:config) { Roro::Configuration.new(options) }

  
  describe 'take_order' do

    Given(:questions)  { config.structure[:choices] }
    Given(:intentions) { config.structure[:intentions] }

    Given { config.stubs(:ask).returns('n')}
    Given { config.take_order }

    Then { intentions.each { |key, value| assert_equal 'n', value  } }
  end
  
  # describe 'story specific variables' do
        
  #   describe 'must not add mysql env vars to pg story' do \
      
  #     Given(:db) { { postgresql: {} } }
  #     Given { config }
      
  #     Then { assert_includes config.env, :postgres_password }
  #     And  { refute config.env.include? :mysql_password }
  #   end
    
  #   describe 'will not add pg env vars to myql story' do 
      
  #     Given(:db) { { mysql: {}} }
  #     Given { config }
      
  #     Then { assert_includes config.env, :mysql_password }
  #     And  { refute config.env.include? :postgres_password }
  #   end
  # end
end