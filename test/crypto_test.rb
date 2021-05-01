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

  describe ":source_files(directory, pattern" do
    Given(:pattern)     { "#{extension}" }
    Given(:source_file) { directory + "/dummy#{pattern}" }
    Given(:execute)     { subject.source_files(directory, pattern) }

    context 'when no files to source must return error' do
      context 'when extension is .env' do
        Given(:error)         { Roro::Crypto::EncryptableError } 
        Given(:error_message) { "No encryptable .env files" }
        
        Then { assert_correct_error }
      end
      
      context 'when extension is .env.enc' do
        Given(:extension)     { '.env.enc' }
        Given(:error)         { Roro::Crypto::DecryptableError } 
        Given(:error_message) { "No decryptable \.env\.enc files" }
        
        Then { assert_correct_error }
      end
    end
    
    context 'when file to source exists' do 
      context 'when nested one level deep' do
        context 'when file is .env' do 
      
          Then { assert_correctly_sourced }
        end
        
        context 'when file is .env.enc' do 
          Given(:extension) { '.env.enc' } 
      
          Then { assert_correctly_sourced }
        end
      end
      
      context 'when nested two levels deep' do
        Given(:directory)  { './roro/env' }
      
        Then { assert_correctly_sourced }
      end

      context 'when nested three levels deep' do
        Given(:directory)  { './roro/containers/app' }
      
        Then { assert_correctly_sourced }
      end
    end
  end
  
  describe ':gather_environments' do
    Given(:execute)   { subject.gather_environments(directory, extension) }
    
    context 'when file extension is .env' do 
      
      Then { assert_correctly_gathered }
    end    
    
    context 'when file extension is .env.enc' do 
      Given(:extension) { '.env.enc' }
    
      Then { assert_correctly_gathered }
    end
    
    context 'when file is nested deeply' do 
      Given(:directory) { './roro/containers/app' }
  
      Then { assert_correctly_gathered }
    end
    
    context 'when file is subenv' do 
      Given { insert_dummy('dummy.subenv') }
      
      Then { assert_equal ['dummy'], execute }
    end
    
    context 'when file is a key' do
      Given(:directory) { './roro/keys' } 
      Given(:extension) { '.key' } 
      Given { insert_key_file }
      Given { insert_key_file('smart') }
      
      Then { assert_equal ['dummy', 'smart'], execute }
    end 
  end

  describe ":write_to_file(data, filename)" do
    Given(:content) { 'export FOO=bar' }
    Given(:execute) { subject.write_to_file(content, file)  }
  
    context 'when .txt extension' do
      Given(:file) { 'example.txt' }
 
      Then { assert_correctly_written }
    end
    
    context 'when .env extension' do
      Given(:file) { 'example.env' }
 
      Then { assert_correctly_written }
    end

    describe 'must raise error when file exists in destination' do 
      Given(:error) { Roro::Crypto::DataDestructionError }
      
      context 'when file is .env' do
        Given(:file) { './roro/dummy.env'}
        Given(:error_message) { "Existing file at ./roro/dummy.env." }

        Then { assert_destruction_error }
      end
      
      context 'when file is .env.enc' do
        Given(:file)          { './roro/dummy.env.enc'}
        Given(:extension)     { '.env.enc' }
        Given(:error_message) { "Existing file at ./roro/dummy.env.enc." }

        Then { assert_destruction_error }
      end
      
      context 'when file is .key' do
        Given(:directory) { './roro/keys'}
        Given(:extension) { '.key' }
        Given(:file) { './roro/keys/dummy.key'}
        Given(:error_message) { "Existing file at ./roro/keys/dummy.key."}

        Then { assert_destruction_error }
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
        
      Then  { assert_equal execute, File.read(key_file).strip }
    end
    
    context 'when key is set in a key file and an environment file' do
      Given { ENV['DUMMY_KEY']=key_in_env_var }
      Given { insert_key_file }
      
      Then  { assert_equal execute, key_in_env_var }
    end
  end

  describe ":encrypt(file, key)" do
    Given(:encryptable_file) { "#{directory}/#{filename}.env" } 
    Given(:execute) { subject.encrypt(encryptable_file, environment) }
      
    context 'when no key and no file' do
      
      Then { assert_raises(Roro::Crypto::KeyError) { execute } } 
    end
    
    context 'when a key and' do 
      Given { insert_key_file } 
      
      context 'when an encryptable file' do
        Given { insert_encryptable_file }  
        Given { execute }
        
        Then  { assert_file './roro/dummy.env.enc' }
      end
      
      context 'when an encryptable subenvfile' do
        Given(:filename) { 'dummy.subenv'}
        Given { insert_encryptable_file(filename) }  
        Given { execute }
        
        Then  { assert_file './roro/dummy.subenv.env.enc' }
      end
    end
  end

  describe ":decrypt(file, key)" do
    Given(:decryptable_file) { "#{directory}/#{filename}.env.enc"}
    Given(:execute) { subject.decrypt(decryptable_file, 'dummy') }

    context 'when no key and no file' do
      
      Then { assert_raises(Roro::Crypto::KeyError) { execute } } 
    end

    context 'when a key and' do
      Given { insert_key_file }
      
      context 'when a decryptable file' do
        Given { insert_decryptable_file }
        Given { execute }
        
        Then  { assert_file './roro/dummy.env'  } 
      end 
      
      context 'when a decryptable subenv file' do
        Given(:filename) { 'dummy.subenv' }
        Given { insert_decryptable_file(filename) }
        Given { execute }
        
        Then  { assert_file './roro/dummy.subenv.env'  } 
        
        context 'when deeply nested' do
          Given(:directory) { './roro/containers'} 
          Given { insert_decryptable_file(filename) }
          Given { execute }
          
          Then  { assert_file './roro/containers/dummy.subenv.env' }
        end 
      end 
    end
  end
  
  describe ':generate_keys(environments, directory, extension' do
    Given(:args)         { [environments, './roro', extension] }
    Given(:execute)      { subject.generate_keys(*args) }

    context 'when no environments supplied and' do 
      Given(:environments) { [] }
    
      context 'when one file matches extension' do
        Given { insert_dummy }  
        Given { execute }
        
        Then { assert_file './roro/keys/dummy.key' }       
      end

      context 'when nested deeply' do
        Given(:directory) { './roro/containers' }
        
        context 'when one file matches an extension' do 
          Given { insert_dummy }  
          Given { execute }
          
          Then { assert_file './roro/keys/dummy.key' }       
        end 
        
        context 'when one file is a subenv' do 
          Given { insert_dummy('dummy.subenv')}
          Given { execute }  
    
          Then  { assert_file './roro/keys/dummy.key' }
        end
        
        context 'when multiple files matches an extension' do 
          Given { insert_dummy('stupid.stupidenv') }
          Given { execute }
          
          Then { assert_file './roro/keys/stupid.key' }       
          Then { refute_file './roro/keys/stupid.stupidenv.key' }       
        end 
      end        

      context 'when no files match an extension' do 
        Given(:error)         { Roro::Crypto::EncryptableError }
        Given(:error_message) { 'No encryptable .env files in ./roro' }      
        
        Then { assert_correct_error }       
      end
    end
    
    context 'when one environment supplied' do
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
      Given(:environments) { nil }
      
      context 'when no encryptable files and no key' do 
        Then { assert_raises(Roro::Crypto::EncryptableError) { execute } }
      end
      
      context 'when no encryptable files and a key' do 
        Given { insert_key_file }
        
        Then  { assert_raises(Roro::Crypto::EncryptableError) { execute } }
      end
       
      context 'when encryptable files and no key' do 
        Given { insert_dummy }
        
        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end
      
      context 'when encryptable files and a key' do
        Given { insert_dummy }
        Given { insert_key_file }
        Given { execute } 
       
        Then  { assert_file './roro/dummy.env.enc' }
      end
        
      context 'when encryptable files and a key and deeply nested' do
        Given(:directory) { './roro/containers/'}
        Given { insert_dummy }
        Given { insert_key_file }
        Given { execute } 
       
        Then  { assert_file './roro/containers/dummy.env.enc' } 
      end
    end 
    
    context 'when one environment supplied' do       
      context 'when key matches encryptable file' do 
        Given { insert_key_file } 
        Given { insert_dummy }
        Given { execute } 
        
        Then  { assert_file './roro/dummy.env.enc' }
      end
      
      context 'when key matches encryptable subenv file' do 
        Given { insert_key_file } 
        Given { insert_dummy('dummy.subenv') }
        Given { execute } 
        
        Then  { assert_file './roro/dummy.subenv.env.enc' }
      end
      
      context 'when environment has no matching key' do 
        Given(:environment) { 'stupid' }
        Given { insert_key_file } 
        Given { insert_dummy }

        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end
      
      context 'when environment does not match any encryptable files' do 
        Given { insert_key_file } 

        Then { assert_raises(Roro::Crypto::EncryptableError) { execute } }
      end
    end
  end
  
  describe ":expose(environments, directory, extension" do
    
    Given(:execute) { subject.expose(environments, directory, '.env.enc') }
    
    context 'when no environments supplied and' do
      Given(:environments) { nil }
      
      context 'when no decryptable files and no key' do 

        Then { assert_raises(Roro::Crypto::EnvironmentError) { execute } }
      end 
       
      context 'when decryptable files and no key' do 
        Given { insert_dummy }
        
        Then { assert_raises(Roro::Crypto::EnvironmentError) { execute } }
      end 
      
      context 'when decryptable files and a key' do 
        Given { insert_decryptable_file }
        Given { insert_key_file }
        Given { execute } 
  
        Then  { assert_file './roro/dummy.env' }
        And   { assert_file './roro/dummy.env.enc' }
      end
    end 
    
    context 'when one environment supplied' do 
      Given(:environment) { 'dummy' }
      
      context 'when no key and no decryptable files' do 

        Then { assert_raises(Roro::Crypto::DecryptableError) { execute } }
      end
      
      context 'when no key and a decryptable file' do 
        Given { insert_decryptable_file }

        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end
      
      context 'when key and no decryptable files' do 
        Given { insert_key_file }

        Then { assert_raises(Roro::Crypto::DecryptableError) { execute } }
      end
      
      context 'when key and decryptable file' do 
        Given { insert_decryptable_file }
        Given { insert_key_file }
        Given { execute }
        
        Then  { assert_file './roro/dummy.env' }
        And   { assert_file './roro/dummy.env.enc' }
      end 
      
      context 'when environment matches encryptable subenv file' do 
        Given { insert_key_file } 
        Given { insert_decryptable_file('dummy.subenv') }
        Given { execute } 
        
        Then  { assert_file './roro/dummy.subenv.env.enc' }
      end
      
      context 'when environment has no key' do 
        Given(:environment) { 'smart' } 
        Given { insert_key_file }
        Given { insert_decryptable_file }

        Then { assert_raises(Roro::Crypto::KeyError) { execute } }
      end
    end
  end 
end