require "test_helper"

class DummyClass ; include Roro::Crypto::File::Reflection ; end

describe Roro::Crypto::File::Reflection do
  before(:all) { prepare_destination 'workbench' }
  
  Given(:subject)   { DummyClass.new }
  Given(:directory) { './roro' }
  
  describe ":source_files(directory, pattern" do
    Given(:execute) { subject.source_files(directory, pattern) }
    Given(:pattern) { '.env' }
    
    context 'when no files match the pattern' do
      
      Then { assert_equal execute, [] }
    end

    context 'when the pattern is .env.enc' do 
      Given { insert_dummy_decryptable }
      Given(:pattern) { '.env.enc' }
    
      Then { assert_includes execute, './roro/dummy.env.enc' }
    end

    context 'when a file matches the pattern' do 
      Given { insert_dummy_encryptable }
                  
      Then { assert_includes execute, './roro/dummy.env' }
    end
    
    context 'when a file is nested two levels deep' do
      Given { insert_dummy('./roro/env/dummy.env') }
      
      Then { assert_includes execute, './roro/env/dummy.env' }
    end
    
    context 'when nested three levels deep' do
      Given { insert_dummy('./roro/containers/app/dummy.env') }
      
      Then { assert_includes execute, './roro/containers/app/dummy.env' }
    end
    
    context 'when pattern contains regex' do 
      Given(:pattern) { 'dummy*.env' }      
      Given { insert_dummy('./roro/dummy.subenv.env') }

      Then  { assert_includes execute, './roro/dummy.subenv.env' }
    end
  end
  
  describe ':gather_environments' do
    Given(:execute)   { subject.gather_environments(directory, extension) }
    Given(:extension) { '.env' } 
    
    context 'when no file matches extension' do     

      Then { assert_raises(Roro::Crypto::EnvironmentError) { execute } } 
    end

    context 'when extension is .env.enc' do
      Given(:extension) { '.env.enc' }
      Given { insert_dummy('./roro/dummy.env.enc') } 
      
      Then { assert_equal execute, ['dummy'] }
    end

    context 'when extension is .env' do
      Given { insert_dummy }
      
      Then  { assert_equal execute, ['dummy']}
    end     

    context 'when file is nested deeply' do 
      Given { insert_dummy './roro/containers/app/dummy.env' }
      
      Then { assert_equal execute, ['dummy'] }
    end
      
    context 'when file is a subenv' do 
      Given { insert_dummy('./roro/dummy.subenv.env') }
      
      Then { assert_equal execute, ['dummy'] }
    end
    
    context 'when files are mixed and nested' do 
      Given { insert_dummy('./roro/containers/app/dummy.subenv.env') }
      Given { insert_dummy('./roro/smart.env') }
      
      Then { assert_includes execute , 'dummy' }
      And  { assert_includes execute , 'smart' }
    end
    
    context 'when files are keys' do
      Given(:directory) { './roro/keys' }
      Given(:extension) { '.key' }
      
      context 'when one key' do 
        Given { insert_key_file }
        
        Then { assert_equal execute, ['dummy'] }
      end
      
      context 'when multiple keys' do 
        Given { insert_key_file }
        Given { insert_key_file('smart.key') }
        
        Then { assert_equal execute.to_set, ['dummy', 'smart'].to_set }
      end
    end 
  end

  describe ":get_key" do
    Given(:key_in_env_var)  { "s0m3k3y-fr0m-variable" }
    Given(:execute)         { subject.get_key('dummy') }

    describe 'when no key set as an environment variable or in key file' do 
      Given(:error)         { Roro::Crypto::KeyError }
      Given(:error_message) { 'No DUMMY_KEY set' }
      
      Then { assert_correct_error }
    end

    context 'when key is set in an environment variable' do
      Given { ENV['DUMMY_KEY']=key_in_env_var }

      Then { assert_equal execute, key_in_env_var }
    end 
    
    context 'when key is set in a key file' do
      Given { insert_file 'dummy_key', key_file }
        
      # Then  { assert_equal execute, File.read(key_file).strip }
    end
    
    context 'when key is set in a key file and an environment file' do
      Given { ENV['DUMMY_KEY']=key_in_env_var }
      Given { insert_key_file }
      
      # Then  { assert_equal execute, key_in_env_var }
    end
  end
end