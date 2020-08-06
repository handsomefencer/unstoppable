require_relative "base_test"

describe Roro::CLI do
  
  get_configuration
      
  describe '.set_from_defaults' do 
 
    Given(:config) { cli.set_from_defaults }
 
    Then { configurable_env_vars.each { |k,v| assert_match v, config[k] } } 
  end
  
  describe ".get_configuration_variables" do
    
    Then { env_vars.each { |key,value| assert_match value, config[key] } }
  end
end
