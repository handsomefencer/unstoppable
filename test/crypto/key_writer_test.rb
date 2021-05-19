require "test_helper"

describe Roro::Crypto::KeyWriter do
  before(:all) { prepare_destination 'crypto' }
  
  Given(:subject) { Roro::Crypto::KeyWriter.new }

  describe '#write_keyfile(environment)' do 
    Given { subject.write_keyfile('dummy') }

    Then  { assert_file('./roro/keys/dummy.key', /=/) }
  end
  
  describe '#write_keyfiles(environments, directory, extension' do
    Given(:execute) { subject.write_keyfiles(environments, './roro', '.env') }
    
    context 'when no environments supplied and' do     
      Given(:environments) { [] }
      
      context 'when file matches extension' do
        Given { insert_dummy }  
        Given { execute }
      
        Then  { assert_file './roro/keys/dummy.key' }       
      end

      context 'when file nested deeply' do
        Given { insert_dummy('./roro/containers/dummy.env') }  
        Given { execute }
        
        Then { assert_file './roro/keys/dummy.key' }       
      end 
      
      context 'when file is subenv' do 
        Given { insert_dummy('./roro/dummy.subenv.env')}
        Given { execute }  
  
        Then  { assert_file './roro/keys/dummy.key' }
      end
      
      context 'when file is nested subenv' do 
        Given { insert_dummy('./roro/containers/dummy.subenv.env')}
        Given { execute }  
  
        Then  { assert_file './roro/keys/dummy.key' }
      end
        
      context 'when multiple files' do 
        Given { insert_dummy }
        Given { insert_dummy('./roro/containers/stupid.stupidenv.env') }
        Given { execute }
        
        Then  { assert_file './roro/keys/stupid.key' }       
        And   { assert_file './roro/keys/dummy.key' }       
      end 

      context 'when no files matching' do 
        Given(:error)         { Roro::Crypto::EnvironmentError }
        Given(:error_message) { 'No files in the ./roro directory matching' }      
        
        Then { assert_correct_error }       
      end
    end
    
    context 'when one environment supplied' do
      Given(:environments) { ['dummy'] }
      Given { execute }  
      
      Then  { assert_file './roro/keys/dummy.key' }
    end 
    
    context 'when multiple environments supplied' do
      Given(:environments) { ['dummy', 'smart', 'stupid'] }  
      
      context 'when no files match the pattern' do 
        Given { execute }  
        
        Then  { assert_file './roro/keys/dummy.key' }        
        And   { assert_file './roro/keys/smart.key' }        
        And   { assert_file './roro/keys/stupid.key' }        
      end
    end
  end
end