require "test_helper"

describe Roro::Crypto::KeyManager do
  before(:all) { prepare_destination 'workbench' }
  
  Given(:subject) { Roro::Crypto::KeyManager.new }

  context 'when no keys have been generated' do 
  
    Then { assert_directory './roro/keys' } 
    And  { assert_directory './roro/containers' }
    And  { assert_directory './roro/env' }
    And  { assert_directory './roro/scripts' } 
  end 

  describe '#generate_keyfile(environment)' do 
    Given { subject.generate_keyfile('dummy') }

    Then  { assert_file('./roro/keys/dummy.key', /=/) }
  end

  
  describe ':generate_keys(environments, directory, extension' do
    Given(:execute) { subject.generate_keys(environments, './roro', '.env') }
    
    context 'when no environments supplied and' do     
      Given(:environments) { [] }
      context 'when file matches extension' do
        Given { insert_dummy }  
        Given { execute }
        
        Then { assert_file './roro/keys/dummy.key' }       
      end

      context 'when file nested deeply' do
        Given { insert_dummy('./roro/containers/dummy.env') }  
        Given { execute }
        
        # Then { assert_file './roro/keys/dummy.key' }       
      end 
      
      context 'when file is subenv' do 
        Given { insert_dummy('./roro/dummy.subenv.env')}
        Given { execute }  
  
        # Then  { assert_file './roro/keys/dummy.key' }
      end
      
      context 'when file is nested subenv' do 
        Given { insert_dummy('./roro/containers/dummy.subenv.env')}
        Given { execute }  
  
        # Then  { assert_file './roro/keys/dummy.key' }
      end
        
      context 'when multiple files' do 
        Given { insert_dummy }
        Given { insert_dummy('./roro/containers/stupid.stupidenv.env') }
        Given { execute }
        
        # Then  { assert_file './roro/keys/stupid.key' }       
        # And   { assert_file './roro/keys/dummy.key' }       
      end 

      context 'when no files matching' do 
        Given(:error)         { Roro::Crypto::EnvironmentError }
        Given(:error_message) { 'No files in the ./roro directory matching' }      
        
        # Then { assert_correct_error }       
      end
    end
    
    context 'when one environment supplied' do
      Given(:environments) { ['dummy'] }
      Given { execute }  
      
      # Then  { assert_file './roro/keys/dummy.kdey' }
    end 
    
    context 'when multiple environments supplied' do
      Given(:environments) { ['dummy', 'smart', 'stupid'] }  
      
      context 'when no files match the pattern' do 
        Given { execute }  
        
        # Then  { assert_file './roro/keys/dummy.key' }        
        # And   { assert_file './roro/keys/smart.key' }        
        # And   { assert_file './roro/keys/stupid.key' }        
      end
    
      context 'when matching environment key exists' do 
        Given { insert_key_file }
        Given(:error)         { Roro::Crypto::DataDestructionError }
        Given(:error_message) { "Existing file at ./roro/keys/dummy.key" }      
        
        # Then { assert_correct_error }
      end
    end
  end
end