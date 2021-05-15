require "test_helper"

describe Roro::Crypto do

  before { 
    prepare_destination 'crypto'
    ENV['DUMMY_KEY']=nil 
  }

  Given(:subject)         { Roro::Crypto }
  Given(:directory)       { './roro' }
  Given(:filename)        { 'dummy' }
  Given(:extension)       { '.env' }
  Given(:key_file)        {'./roro/keys/dummy.key'}
  Given(:environments)    { [environment] }
  Given(:environment)     { 'dummy' }
  
  describe ':generate_key' do

    Then { assert_equal subject.generate_key.size, 25 }
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
        
      Then  { assert_equal execute, File.read(key_file).strip }
    end
    
    context 'when key is set in a key file and an environment file' do
      Given { ENV['DUMMY_KEY']=key_in_env_var }
      Given { insert_key_file }
      
      Then  { assert_equal execute, key_in_env_var }
    end
  end

  describe ":encrypt(file, key)" do
    Given(:encryptable) { "./roro/dummy.env" } 
    Given(:execute) { subject.encrypt(encryptable, environment) }
      
    context 'when no key and no file' do
      
      Then { assert_raises(Roro::Crypto::KeyError) { execute } } 
    end
    
    context 'when a key and' do 
      Given { insert_key_file } 
      
      context 'when an encryptable file' do
        Given { insert_dummy_encryptable }  
        Given { execute }
        
        Then  { assert_file './roro/dummy.env.enc' }
      end
      
      context 'when an encryptable subenvfile' do
        Given(:encryptable) { './roro/dummy.subenv.env'}
        Given { insert_dummy_encryptable('./roro/dummy.subenv.env') }  
        Given { execute }
        
        Then  { assert_file './roro/dummy.subenv.env.enc' }
      end
    end
  end

  describe ":decrypt(file, key)" do
    Given(:decryptable) { './roro/dummy.env.enc'}
    Given(:execute) { subject.decrypt(decryptable, 'dummy') }

    context 'when no key and no file' do
      
      Then { assert_raises(Roro::Crypto::KeyError) { execute } } 
    end

    context 'when a key and' do
      Given { insert_key_file }
      
      context 'when a decryptable file' do
        Given { insert_dummy_decryptable }
        Given { execute }
        
        Then  { assert_file './roro/dummy.env'  } 
      end 
      
      context 'when a decryptable subenv file' do
        Given(:decryptable) { './roro/dummy.subenv.env.enc' }
        Given { insert_dummy_decryptable(decryptable) }
        Given { execute }
        
        Then  { assert_file './roro/dummy.subenv.env'}
        And   { assert_file './roro/dummy.subenv.env.enc'  } 
      end 
        
      context 'when a deeply nested decryptable subenv' do
        Given(:decryptable) { './roro/containers/dummy.subenv.env.enc' }
        Given { insert_dummy_decryptable(decryptable) }
        Given { execute }
        
        Then  { assert_file './roro/containers/dummy.subenv.env'}
      end 
    end
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
    
      context 'when matching environment key exists' do 
        Given { insert_key_file }
        Given(:error)         { Roro::Crypto::DataDestructionError }
        Given(:error_message) { "Existing file at ./roro/keys/dummy.key" }      
        
        Then { assert_correct_error }
      end
    end
  end
  
  describe ":obfuscate(environments, directory, extension" do
    Given(:execute) { subject.obfuscate(environments, directory, extension) }
    
    context 'when no environments supplied and' do
      Given(:environments) { [] }
      Given(:error) { Roro::Crypto::EnvironmentError }
      
      context 'when no encryptable files and no key' do 
      
        Then { assert_raises(error) { execute } }
      end
      
      context 'when no encryptable files and a key' do 
        Given { insert_key_file }
        
        Then  { assert_raises(error) { execute } }
      end
       
      context 'when encryptable files and no key' do 
        Given { insert_dummy }
        
        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end
      
      context 'when encryptable files and a key' do
        Given { insert_dummy_encryptable }
        Given { insert_key_file }
        Given { execute } 

        Then  { assert_file './roro/dummy.env.enc' }
      end
        
      context 'when deeply nested encryptable files and a key' do
        Given { insert_dummy_encryptable('./roro/containers/dummy.env') }
        Given { insert_key_file }
        Given { execute } 
        
        Then  { assert_file './roro/containers/dummy.env.enc' } 
      end
    end 
    
    context 'when environment supplied has no matching key' do 
      Given(:environments)  { ['getsome'] }
      Given { insert_dummy_encryptable }
    
      Then  { assert_raises(Roro::Crypto::KeyError) { execute} }
    end
    
    context 'when one environment supplied and matching key' do       
      Given { insert_key_file }
      
      context 'when key matches encryptable file' do 
        Given { insert_dummy_encryptable }
        Given { execute } 
        
        Then  { assert_file './roro/dummy.env.enc' }
      end
      
      context 'when key matches encryptable subenv file' do 
        Given { insert_dummy_encryptable('./roro/dummy.subenv.env') }
        Given { execute } 
        
        Then  { assert_file './roro/dummy.subenv.env.enc' }
      end
    end
  end
  
  describe ":expose(environments, directory, extension" do
    Given(:execute) { subject.expose(environments, directory, '.env.enc') }
    
    context 'when no environments supplied and' do
      Given(:environments) { [] }
      
      context 'when no decryptable files and no key' do 

        Then { assert_raises(Roro::Crypto::EnvironmentError) { execute } }
      end 
       
      context 'when decryptable files and no key' do 
        Given { insert_dummy }
        
        Then { assert_raises(Roro::Crypto::EnvironmentError) { execute } }
      end 
      
      context 'when decryptable files and a key' do 
        Given { insert_dummy_decryptable }
        Given { insert_key_file }
        Given { execute } 
  
        Then  { assert_file './roro/dummy.env' }
        And   { assert_file './roro/dummy.env.enc' }
      end
    end 
    
    context 'when one environment supplied' do 
      context 'when no key and a decryptable file' do 
        Given { insert_dummy_decryptable }

        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end
      
      context 'when key and decryptable file' do 
        Given { insert_key_file }
        Given { insert_dummy_decryptable }
        
        describe 'must decrypt file' do 
          Given { execute }
          
          Then  { assert_file './roro/dummy.env' }
        end
        
        describe 'will not decrypt any other file' do
          Given(:environments) { ['dummy']}
          Given { insert_dummy_decryptable('./roro/smart.env.enc') }
          Given { insert_key_file('smart.key') }
          Given { execute }
          
          Then  { refute_file './roro/smart.env' }
          And   { assert_file './roro/smart.env.enc' }
          And   { assert_file './roro/dummy.env' }
          And   { assert_file './roro/dummy.env.enc' }
        end
      end
      
      context 'when environment matches encryptable subenv file' do 
        Given { insert_key_file } 
        Given { insert_dummy_decryptable('./roro/dummy.subenv.env.enc') }
        Given { execute } 
        
        Then  { assert_file './roro/dummy.subenv.env.enc' }
      end
    end
  end 
end