require "test_helper"

describe Roro::Crypto::KeyWriter do
  let(:workbench) { 'crypto/roro'}
  let(:subject)   { Roro::Crypto::KeyWriter.new }

  describe '#write_keyfile(environment)' do
    Given { subject.write_keyfile 'dummy' }
    Then  { assert_file 'roro/keys/dummy.key', /=/ }
  end
  
  describe '#write_keyfiles(environments, directory, extension' do
    let(:execute) { subject.write_keyfiles environments, './roro', '.env' }
    
    context 'when no environments supplied and' do     
      let(:environments) { [] }
      
      context 'when file matches extension' do
        Given { insert_dummy }
        Given { execute }
      
        Then  { assert_file 'roro/keys/dummy.key' }
      end

      context 'when file nested deeply' do
        Given { insert_dummy 'roro/containers/dummy.env' }
        Given { execute }
        
        Then { assert_file 'roro/keys/dummy.key' }
      end 
      
      context 'when file is subenv' do 
        Given { insert_dummy 'roro/dummy.subenv.env'}
        Given { execute }  
  
        Then  { assert_file 'roro/keys/dummy.key' }
      end
      
      context 'when file is nested subenv' do 
        Given { insert_dummy 'roro/containers/dummy.subenv.env' }
        Given { execute }  
  
        Then  { assert_file 'roro/keys/dummy.key' }
      end
        
      context 'when multiple files' do 
        Given { insert_dummy }
        Given { insert_dummy('./roro/containers/stupid.stupidenv.env') }
        Given { execute }
        
        Then  { assert_file './roro/keys/stupid.key' }       
        And   { assert_file './roro/keys/dummy.key' }       
      end 

      context 'when no files matching' do 
        let(:error)         { Roro::Crypto::EnvironmentError }
        let(:error_message) { 'No .env files in ./roro' }
        
        Then { assert_correct_error }       
      end
    end
    
    context 'when one environment supplied' do
      let(:environments) { ['dummy'] }
      Given { execute }  
      
      Then  { assert_file './roro/keys/dummy.key' }
    end 
    
    context 'when multiple environments supplied' do
      let(:environments) { ['dummy', 'smart', 'stupid'] }  
      
      context 'when no files match the pattern' do 
        Given { execute }  
        
        Then  { assert_file './roro/keys/dummy.key' }        
        And   { assert_file './roro/keys/smart.key' }        
        And   { assert_file './roro/keys/stupid.key' }        
      end
    end
  end
end