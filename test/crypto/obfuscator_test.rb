require "test_helper"
describe Roro::Crypto::Obfuscator do
  before(:all)           { prepare_destination 'crypto' }

  Given(:subject)         { Roro::Crypto::Obfuscator.new }
  Given(:directory)       { './roro' }
  Given(:extension)       { '.env' }
  Given(:environments)    { ['dummy'] }  
  
  describe '#obfuscate_file(file, key)' do 
    Given(:key)            { 'XLF9IzZ4xQWrZo5Wshc5nw==' }
    Given { insert_dummy_encryptable }
    Given { subject.obfuscate_file("./roro/dummy.env", key) }

    Then { assert_file './roro/dummy.env.enc' }
  end
  
  describe '#obfuscate(envs, dir, ext)' do
    Given(:execute) { subject.obfuscate(environments, directory, extension) }
    
    describe 'when environments empty' do 
      Given(:environments) { [] }

      Then { assert_raises(Roro::Crypto::EnvironmentError) { execute} }
    end
    
    context 'when obfuscatable but no matching key' do 
      Given { insert_dummy_encryptable }    
      
      Then { assert_raises(Roro::Crypto::KeyError) { execute} }
    end
    
    context 'when obfuscatable and matching key' do
      Given { insert_key_file } 
      Given { insert_dummy_encryptable }    
      Given { execute }
      
      Then  { assert_file './roro/dummy.env.enc' }
    end     
    
    context 'when obfuscatable is subenv' do
      Given { insert_key_file } 
      Given { insert_dummy_encryptable('./roro/dummy.subenv.env') }  
      Given { execute }
      
      Then  { assert_file './roro/dummy.subenv.env.enc' }
    end

    context 'when obfuscatable is nested deeply' do
      Given(:deeply_nested) { './roro/dummy.subenv.env' }
      Given { insert_key_file } 
      Given { insert_dummy_encryptable(deeply_nested) }  
      Given { execute }
      
      Then  { assert_file './roro/dummy.subenv.env.enc' }
    end
  end
end