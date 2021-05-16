require "test_helper"
describe Roro::Crypto::Exposer do
  before(:all)           { prepare_destination 'workbench' }
  
  Given(:directory)       { './roro' }
  Given(:filename)        { 'dummy' }
  Given(:environments)    { [environment] }
  Given(:environment)     { 'dummy' }
  
  Given(:subject)         { Roro::Crypto::Exposer.new }
  
  describe '#expose_file(file, key)' do 
    Given(:key) { File.read('./roro/keys/dummy.key').strip }
    Given { insert_key_file }
    Given { insert_dummy_decryptable }
    Given { subject.expose_file("./roro/dummy.env.enc", key) }

    Then { assert_file './roro/dummy.env', /DATABASE_HOST/ }
  end
  
  describe '#expose(envs, dir, ext)' do
    Given(:execute) { subject.expose(environments, directory, '.env.enc') }
    
    context 'when no environments supplied and' do 
      Given(:environments) { [] }

      context 'when no exposable files and no key' do 

        Then { assert_raises(Roro::Crypto::EnvironmentError) { execute} }
      end

      context 'when exposable files and no key' do 
        Given { insert_dummy_decryptable }    

        Then { assert_raises(Roro::Crypto::KeyError) { execute} }
      end 

      context 'when exposable files and matching key' do
        Given { insert_dummy_decryptable }    
        Given { insert_key_file } 
        Given { execute }
        
        Then  { assert_file './roro/dummy.env' }
        And   { assert_file './roro/dummy.env.enc' } 
      end     

      context 'when exposable is a subenv' do
        Given { insert_key_file } 
        Given { insert_dummy_decryptable('./roro/dummy.subenv.env.enc') }  
        Given { execute }
        
        Then  { assert_file './roro/dummy.subenv.env' }
      end

      context 'when exposable is deeply nested' do
        Given(:deeply_nested) { './roro/containers/dummy.subenv.env.enc' }
        Given { insert_key_file } 
        Given { insert_dummy_decryptable(deeply_nested) }  
        Given { execute }
        
        Then  { assert_file './roro/containers/dummy.subenv.env' }
        Then  { assert_file './roro/containers/dummy.subenv.env.enc' }
      end
    end

    context 'when one environment supplied' do 
      context 'when no matching key or decryptable files' do 
        Given(:environments) { ['dummy']}

        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end

      context 'when no matching key but matching decryptable files' do 
        Given { insert_dummy_decryptable }

        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end
      
      context 'when matching key and decryptable files' do 
        Given { insert_key_file }
        Given { insert_dummy_decryptable }
        Given { insert_dummy_decryptable('./roro/smart.env.enc') }
        
        describe 'must decrypt file' do 
          Given { execute }
          
          Then  { assert_file './roro/dummy.env' }
          And   { assert_file './roro/dummy.env.enc' }
        end

        describe 'must not decrypt any other file' do 
          Given { execute }
          
          Then  { refute_file './roro/smart.env' }
          And   { assert_file './roro/smart.env.enc' }
        end 
      end
    end
  end
end