require "test_helper"
require "dummy_file_reflection"

describe Roro::Crypto::FileReflection do
  before { prepare_destination 'workbench' }
  Given(:subject) { DummyClass.new }
  
  Given(:directory)       { './roro' }
  Given(:filename)        { 'dummy' }
  Given(:extension)       { '.env' }
  Given(:key_file)        {'./roro/keys/dummy.key'}
  Given(:environments)    { [environment] }
  Given(:environment)     { 'dummy' }
    
  describe ":source_files(directory, pattern" do
    Given(:execute)     { subject.source_files(directory, pattern) }
    
    context 'when pattern is .env.enc' do 
      Given { insert_dummy_decryptable }
      Given(:pattern) { '.env.enc' }
    
      Then { assert_includes execute, './roro/dummy.env.enc' }
    end
    
    context 'when pattern is .env' do 
      Given(:pattern) { '.env' }
      
      context 'when no files matching pattern' do
        Then { assert_equal execute, [] }
      end
    
      context 'when a file matches pattern' do 
        context 'when nested one level deep' do
          Given { insert_dummy_encryptable }
                    
          Then { assert_includes execute, './roro/dummy.env' }
        end
        
        context 'when nested two levels deep' do
          Given { insert_dummy('./roro/env/dummy.env') }
          Then { assert_file './roro/env/dummy.env'}
        
          Then { assert_includes execute, './roro/env/dummy.env' }
        end
        
        context 'when nested three levels deep' do
          Given { insert_dummy('./roro/containers/app/dummy.env') }
          
          Then { assert_includes execute, './roro/containers/app/dummy.env' }
        end
      end
    end
    
    context 'when pattern is dummy*.env' do 
      Given(:pattern) { 'dummy*.env' }      
      Given { insert_dummy('./roro/dummy.subenv.env') }
      Given { insert_dummy }

      Then  { assert_includes execute, './roro/dummy.subenv.env' }
      And   { assert_includes execute, './roro/dummy.env' }
    end
  end
  
  describe ':gather_environments' do
    Given(:execute) { subject.gather_environments(directory, extension) }
    
    context 'when file extension is .env.enc' do
      Given { insert_dummy('./roro/dummy.env.enc') } 
      Given(:extension) { '.env.enc' }
      
      Then { assert_equal execute, ['dummy'] }
    end

    context 'when file extension is .env' do
      Given(:extension) { '.env' } 
      Given { insert_dummy }
      
      Then  { assert_equal execute, ['dummy']}
            
      context 'when file is nested deeply' do 
        Given { insert_dummy './roro/containers/app/dummy.env' }
        
        Then { assert_equal execute, ['dummy'] }
      end
      
      context 'when file is subenv' do 
        Given { insert_dummy('./roro/dummy.subenv.env') }
        
        Then { assert_equal execute, ['dummy'] }
      end
      
      context 'when files are mixed and nested' do 
        Given { insert_dummy('./roro/containers/app/dummy.subenv.env') }
        Given { insert_dummy('./roro/smart.env') }
        
        Then { assert_includes execute , 'dummy' }
        And  { assert_includes execute , 'smart' }
      end
    end
    
    context 'when files are keys' do
      Given(:execute) { subject.gather_environments('./roro/keys', '.key')}
      
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
end