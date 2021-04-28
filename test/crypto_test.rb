require "test_helper"

describe Roro::Crypto do
  before do 
    prepare_destination 'crypto'
  end

  Given(:subject)   { Roro::Crypto }
  Given(:directory) { './roro' }
  Given(:extension) { '.env' }

  
  describe ':generate_key' do

    Then { assert_equal subject.generate_key.size, 25 }
  end

  describe ":source_files(directory, extensions" do
    Given(:source_file) { directory + "/dummy#{extension}" }
    Given(:args)        { [directory, extension] }
    Given(:execute)     { subject.source_files(*args) }

    context 'when no files to source' do
      context 'when extension is .env' do
        Given(:error)         { Roro::Crypto::EncryptableError } 
        Given(:error_message) { "No encryptable .env files" }
        
        Then { assert_expected_error }
      end
      
      context 'when extension is .env.enc' do
        Given(:extension)     { '.env.enc' }
        Given(:error)         { Roro::Crypto::DecryptableError } 
        Given(:error_message) { "No decryptable \.env\.enc files" }
        
        Then { assert_expected_error }
      end
    end
    
    context 'when file to source exists' do 
      context 'when nested one level deep' do
        context 'when file is .env' do 
      
          Then { assert_sourced_correctly }
        end
        
        context 'when file is .env.enc' do 
          Given(:extension) { '.env.enc' } 
      
          Then { assert_sourced_correctly }
        end
      end
      
      context 'when nested two levels deep' do
        Given(:directory)  { './roro/env' }
      
        Then { assert_sourced_correctly }
      end

      context 'when nested three levels deep' do
        Given(:directory)  { './roro/containers/app' }
      
        Then { assert_sourced_correctly }
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
    before { ENV['DUMMY_KEY']=nil }
      
    Given(:key_file)        {'./roro/keys/dummy.key'}
    Given(:key_in_env_var)  { "s0m3k3y-fr0m-variable" }
    Given(:execute)         { subject.get_key('dummy') }

    describe 'when no key set as an environment variable or in key file' do 
      Given(:error)         { Roro::Crypto::KeyError }
      Given(:error_message) { 'No DUMMY_KEY set' }
      
      Then { assert_expected_error }
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
      Given { insert_file 'dummy_key', key_file }
      
      Then  { assert_equal execute, key_in_env_var }
    end
  end

  describe ":encrypt(file, key)" do
    before { skip }

    Given(:encrypt) { -> (file) {
      insert_file 'dummy_env', file
      subject.encrypt(file, 'dummy') } }

    Given { insert_file 'dummy_key', 'roro/keys/dummy.key'}

    context 'when file is in ./roro/' do

      Given { encrypt['./roro/dummy.env'] }

      Then  { assert_file './roro/dummy.env.enc' }
    end

    context 'when file is in ./roro/containers/' do

      Given { encrypt['./roro/containers/dummy.env'] }

      Then  { assert_file './roro/containers/dummy.env.enc' }
    end

    context 'when file is for a subenv' do

      Given { encrypt['./roro/containers/dummy.subenv.env'] }

      Then  { assert_file './roro/containers/dummy.subenv.env.enc' }
    end
  end

  describe ":decrypt(file, key)" do
    before { skip }
    Given { insert_file 'dummy_key', 'roro/keys/dummy.key' }

    Given(:decrypt) { -> (file) {
      insert_file 'dummy_env_enc', file
      subject.decrypt(file, 'dummy') } }

    context 'when encrypted file lives in' do 
      context './roro/' do
        Given { decrypt['./roro/dummy.env.enc'] }

        Then  { assert_file './roro/dummy.env' }
      end
      
      context './roro/env/' do
        Given { decrypt['./roro/env/dummy.env.enc'] }

        Then  { assert_file './roro/env/dummy.env' }
      end

      context './roro/env/containers/database' do
        Given { decrypt['./roro/containers/database/env/dummy.env.enc'] }

        Then  { assert_file './roro/containers/database/env/dummy.env' }
      end
    end
  end
  
  describe ':generate_keys(environments, directory, extensions' do
    before { skip }
    Given(:environments) { nil }
    Given(:directory)    { './roro' }
    Given(:extensions)   { ['.env'] }
    Given(:args)         { [environments, directory, extensions] }
    Given(:execute)      { subject.generate_keys(*args) }

    
    context 'when no environments supplied and no files matching extensions' do 
      Given(:error)         { Roro::Crypto::EnvironmentError }
      Given(:error_message) { 'No files in the ./roro directory matching .env' }      
      
      Then { assert_expected_error }       
    end
    
    context 'when environments supplied but matching environment key exists' do 
      Given { insert_file 'dummy_key', file }
      Given(:file) { './roro/keys/dummy.key' }
      Given(:environments)  { ['dummy'] }
      Given(:error)         { Roro::Crypto::DataDestructionError }
      Given(:raise_error)   { assert_raises(error) { execute } }
      
      Then { assert_equal destruction_message[file], raise_error.message }
    end
  end
  
  describe ":obfuscate(environments, directory, extension" do
    Given(:envfile) { insert_file 'dummy_env', './roro/env/dummy.env' }
    Given(:keyfile) { insert_file 'dummy_key', './roro/keys/dummy.key' }
    Given(:obfuscate) { subject.obfuscate(environments, './roro/env', '.env') }

    context 'when no key' do
      Given(:environments) { ['dummy'] }
      Given { envfile } 
      Given { obfuscate }
      
      # Then  { assert_file './roro/env/dummy.env.enc' }
      # context 'when no key file' do
      # environments specified' do 
        
      # end
    end 
    
    context 'when environments nil' do 
      Given(:environments) { nil }
      Given { obfuscate }
      
      # Then  { assert_file './roro/env/dummy.env.enc' }
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
  
  def insert_dummy
    insert_file 'dummy_env', "#{directory}/dummy#{extension}"
  end
    
  def assert_expected_error
    returned = assert_raises(error) { execute }
    assert_match error_message, returned.message 
  end 
  
  def assert_destruction_error 
    insert_dummy 
    assert_expected_error
  end
  
  def assert_correctly_written
    execute
    assert_equal File.read(file), content 
  end    
  
  def assert_sourced_correctly
    insert_dummy
    assert_includes execute, source_file 
  end 
  
  def assert_correctly_gathered 
    insert_dummy
    assert_equal ['dummy'], execute
  end 
end