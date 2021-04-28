require "test_helper"

describe Roro::Crypto do

  before { 
    prepare_destination 'crypto'
    ENV['DUMMY_KEY']=nil 
  }

  Given(:subject)         { Roro::Crypto }
  Given(:directory)       { './roro' }
  Given(:extension)       { '.env' }
  Given(:key_file)        {'./roro/keys/dummy.key'}
  Given(:environments)    { ['dummy']}
  
  describe ':generate_key' do

    Then { assert_equal subject.generate_key.size, 25 }
  end

  describe ":source_files(directory, pattern" do
    Given(:pattern)     { "#{extension}" }
    Given(:source_file) { directory + "/dummy#{pattern}" }
    Given(:args)        { [directory, pattern] }
    Given(:execute)     { subject.source_files(*args) }

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
      focus
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
    Given(:file) { "#{directory}/dummy.env" }
    Given(:execute) { 
      insert_key_file
      insert_file 'dummy_env', file
      subject.encrypt(file, 'dummy') }
    
    context 'when file is in ./roro/' do
      Given { execute }

      Then  { assert_file './roro/dummy.env.enc' }
    end

    context 'when file is in ./roro/containers/' do
      Given(:directory) { './roro/containers' }
      Given { execute }

      Then  { assert_file './roro/containers/dummy.env.enc' }
    end

    context 'when file is for a subenv' do
      Given(:file)   { './roro/dummy.subenv.env' }
      Given { execute }
      
      Then  { assert_file('./roro/dummy.subenv.env.enc') }
    end
  end

  describe ":decrypt(file, key)" do
    Given { insert_key_file }

    Given(:execute) { 
      insert_file 'dummy_env_enc', file
      subject.decrypt(file, 'dummy') 
    }

    context 'when encrypted file is a subenv' do 
      Given(:file) { './roro/dummy.subenv.env.enc' }
      Given { execute }

      Then  { assert_file './roro/dummy.subenv.env' }
    end 
      
    context 'when encrypted file lives in' do 
      context './roro/' do
        Given(:file) { './roro/dummy.env.enc' }
        Given { execute }

        Then  { assert_file './roro/dummy.env' }
      end
      
      context './roro/env/' do
        Given(:file) { './roro/env/dummy.env.enc' }
        Given { execute }

        Then  { assert_file './roro/env/dummy.env' }
      end

      context './roro/env/containers/database' do
        Given(:file) { './roro/containers/database/env/dummy.env.enc' }
        Given { execute }

        Then  { assert_file './roro/containers/database/env/dummy.env' }
      end
    end
  end
  
  describe ':generate_keys(environments, directory, extension' do
    Given(:args)         { [environments, './roro', extension] }
    Given(:execute)      { subject.generate_keys(*args) }

    context 'when no environments supplied and' do 
      Given(:environments) { nil }
    
      context 'when one file matches extension' do 
        Given { insert_dummy }  
        Given { execute }
        
        Then { assert_file './roro/keys/dummy.key' }       
      end

      context 'when nested deeply' do
        Given(:directory) { './roro/containers/app' }
        Given { insert_dummy }  
        
        context 'when one file matches an extension' do 
          Given { execute }
          
          Then { assert_file './roro/keys/dummy.key' }       
        end 
        
        context 'when one file is a subenv' do 
          Given { insert_dummy('smart.subenv')}
          Given { execute }  
    
          Then  { assert_file './roro/keys/smart.key' }
          And   { assert_file './roro/keys/dummy.key' }
          And   { refute_file './roro/keys/smart.subenv.key' }
        end
        
        context 'when multiple files matches an extension' do 
          Given { 
            insert_dummy('smart')
            insert_dummy('stupid') }
            
          Given { execute }
          
          Then { 
            assert_file './roro/keys/dummy.key'
            assert_file './roro/keys/smart.key'
            assert_file './roro/keys/stupid.key' }       
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
        
        Then  { 
          assert_file './roro/keys/dummy.key'        
          assert_file './roro/keys/smart.key'        
          assert_file './roro/keys/stupid.key' }       
      end
    
      context 'when a file matches the pattern' do 
        Given { insert_dummy('smart') }
        Given { execute }  
        
        Then  { assert_file './roro/keys/smart.key' }       
      end

      context 'when no files match the extension' do 
        Given { execute }
        
        Then  { assert_file './roro/keys/dummy.key' }
      end 
      
      context 'when matching environment key exists' do 
        Given { insert_key_file }
        Given(:environments)  { ['dummy'] }
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
      
      context 'when no encryptable files' do 
        Then { assert_raises(Roro::Crypto::EncryptableError) { execute } }
      end 
       
      context 'when encryptable files and' do 
        Given { insert_dummy }
        
        context 'when no key' do

          Then { assert_raises(Roro::Crypto::KeyError) { execute } }
        end

        context 'when a matching key' do
          Given { insert_key_file }
          Given { execute } 
          Then  { assert_file './roro/dummy.env.enc' }
        end
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
      
      context 'when environment does not match any encryptable files' do 
        Given { insert_key_file } 
        Given { insert_file './dummy_env', './roro/smart.env' }

        # Then { 
        #   assert_file './roro/keys/dummy.key'
        #   refute_file './roro/keys/smart.key'
        # }
        # Then { assert_file './roro/smart.env.enc'}
        # Then { assert_raises(Roro::Crypto::EncryptableError) { execute } }
      end
    end
    context 'when called with key, directory, and extension arguments' do 
      context 'when all match' do 
        Given { subject.obfuscate(['dummy'], './roro/env', '.env') }
        
        # Then  { assert_file './roro/env/dummy.env.enc' }
      end
      
      context 'when different key' do 
        Given { insert_file 'dummy_key', './roro/keys/production.key' }
        Given { subject.obfuscate('production', './roro/env', '.env') }
      
        # Then  { assert_file './roro/env/dummy.env.enc' }
      end
      
      context 'when directory' do 
        Given { insert_file 'dummy_env', './roro/containers/app/dummy.env' }
        Given { subject.obfuscate(nil, './roro/containers/app', '.env') }
      
        describe 'must encrypt file in specified directory' do 
          # Then  { assert_file './roro/containers/app/dummy.env.enc' }
        end 
        
        describe 'will not encrypt file in unspecified directory' do 
          # Then  { refute_file './roro/env/dummy.env.enc' }
        end 
      end
      
      context 'when called without arguments' do 
        Given { insert_file 'dummy_key', './roro/keys/production.key' }
        Given { insert_file 'dummy_key', './roro/keys/development.key' }
        Given { insert_file 'dummy_key', './roro/keys/test.key' }
        
        context 'when multiple .env files' do 
          Given { insert_file 'dummy_env', './roro/env/production.env' }
          Given { insert_file 'dummy_env', './roro/env/development.env' }
          Given { insert_file 'dummy_env', './roro/env/test.env' }
          
          describe 'must obfuscate all files' do 
            Given { subject.obfuscate }
          
            # Then  { assert_file './roro/env/production.env.enc' }
            # And   { assert_file './roro/env/development.env.enc' }
            # And   { assert_file './roro/env/test.env.enc' }
          end
        end 
        
        context 'when some .env files are subenvs' do
          Given { insert_file 'dummy_key', './roro/keys/staging.key' }
          Given { insert_file 'dummy_env', './roro/env/staging.sub.env.env' }
          Given { subject.obfuscate }
          
          # Then  { assert_file './roro/env/staging.sub.env.env.enc' }
        end 
      end
    end
  end
  
  def insert_dummy(filename='dummy')
    insert_file 'dummy_env', "#{directory}/#{filename}#{extension}"
  end
  
  def insert_key_file(environment='dummy_key') 
    insert_file environment, key_file
  end
    
  def assert_correct_error
    returned = assert_raises(error) { execute }
    assert_match error_message, returned.message 
  end 
  
  def assert_destruction_error 
    insert_dummy 
    assert_correct_error
  end
  
  def assert_correctly_written
    execute
    assert_equal File.read(file), content 
  end    
  
  def assert_correctly_sourced
    insert_dummy
    assert_includes execute, source_file 
  end 
  
  def assert_correctly_gathered 
    insert_dummy
    assert_equal ['dummy'], execute
  end 
end