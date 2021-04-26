require "test_helper"

describe Roro::Crypto do
  Given { prepare_destination 'crypto' }
  Given { ENV['DUMMY_KEY'] = nil }

  Given(:subject) { Roro::Crypto }
  Given(:env_var) { 'export FOO=bar' }

  describe ':generate_key' do

    Then { assert_equal subject.generate_key.size, 25 }
  end

  describe ":write_to_file(data, filename)" do
    Given(:write_to_file) { -> (file) { subject.write_to_file(env_var, file) } }

    context 'when .txt extension' do

      Given { write_to_file['example.txt'] }

      Then { assert_equal File.read('example.txt'), "export FOO=bar"}
    end

    context 'when .env extension' do
      Given { write_to_file['example.env']}

      Then { assert_equal File.read('example.env'), "export FOO=bar"}
    end

    context 'when file exists extension' do

      Given { write_to_file['example.env'] }

      Then { assert_equal File.read('example.env'), "export FOO=bar"}
    end

    context 'when matching file exists must raise DataDestructionError' do
      Given(:error)     { Roro::Crypto::DataDestructionError }
      Given(:error_msg) { assert_raises(Roro::Crypto::DataDestructionError) { 
        insert_file 'dummy_key', file
        write_to_file[file] } }
      
      Given(:file) { './roro/keys/dummy.key'}
      Given { insert_file 'dummy_key', file }

      Then { assert_raises(error) { subject.write_to_file(env_var, file)  }} 

      describe 'with error message' do
        context 'when .key file' do 
          Given(:file) { './roro/keys/dummy.key'}

          Then { assert_match 'dummy.key exists', error_msg.message } 
        end
        
        context 'when .env file' do 
          Given(:file) { './roro/env/dummy.env'}

          Then { assert_match 'dummy.env exists', error_msg.message } 
        end
        
        context 'when .env.enc file' do 
          Given(:file) { './roro/env/dummy.env.enc'}

          Then { assert_match 'dummy.env.enc exists', error_msg.message } 
        end
      end
    end
  end

  describe ":write_key_to_file(target_directory, key_name)" do

    Given { subject.write_key_to_file('roro/keys', "deploy") }

    Then  { assert_equal File.read('./roro/keys/deploy.key').size, 25 }
  end

  describe ":source_files" do
    Given { insert_file 'dummy_env', destination }
    Given(:pattern)      { '.env.fixture' }
    Given(:source_files) { subject.source_files(destination_dir, '.env' ) }
    Given(:destination)     { destination_dir + '/dummy.env' }

    context 'when not in ./roro/' do
      Given(:error) { Roro::Crypto::SourceDirectoryError }

      context 'when in base directory' do
        When(:destination_dir) { './' }
        Then { assert_raises(error) { source_files } }
      end

      context 'when roro is not first folder in path' do
        When(:destination_dir) { './not_roro' }
        Then { assert_raises(error) { source_files } }
      end
    end

    context 'when in base directory of ./roro' do
      When(:destination_dir) { './roro' }

      Then { assert_includes source_files, destination }
    end

    context 'when nested one level' do
      When(:destination_dir) { './roro/containers' }

      Then { assert_includes source_files, destination }
    end

    context 'when nested two levels' do
      When(:destination_dir) { './roro/containers/app' }

      Then { assert_includes source_files, destination }
    end

    context 'when nested three levels' do
      When(:destination_dir) { './roro/containers/database/env' }

      Then { assert_includes source_files, destination }
    end
  end

  describe ":get_key" do
    Given(:key_from_env)    { "s0m3k3y-fr0m-variable" }
    Given(:key_in_key_file) { insert_file 'dummy_key', './roro/keys/dummy.key' }

    context 'when key is not set' do
      Given(:get_key) {  subject.get_key('dummy') }

      describe 'must return error' do

        Then { assert_raises(Roro::Crypto::KeyError) { get_key } }
      end

      describe 'returned error message' do
        Given(:error) { assert_raises(Roro::Crypto::KeyError) { get_key } }

        Then { assert_match 'No DUMMY_KEY set', error.message }
      end
    end

    context 'when key set in' do
      context 'an environment variable' do
        Given { ENV['DUMMY_KEY'] = "s0m3k3y-fr0m-variable" }

        Then { assert_equal subject.get_key('dummy'), key_from_env }
      end

      context 'an environment variable and in a key file' do
        Given { ENV['DUMMY_KEY'] = "s0m3k3y-fr0m-variable" }
        Given { key_in_key_file }

        Then  { assert_equal subject.get_key('dummy'), key_from_env }
      end

      context 'in a key file' do
        Given { key_in_key_file }
        Given(:key_from_file) { 'XLF9IzZ4xQWrZo5Wshc5nw==' }

        Then { assert_equal subject.get_key('dummy'), key_from_file }
      end
    end
  end

  describe ":encrypt(file, key)" do

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
    Given { insert_file 'dummy_key', 'roro/keys/dummy.key' }

    Given(:decrypt) { -> (file) {
      insert_file 'dummy_env_enc', file
      subject.decrypt(file, 'dummy') } }

    context 'when encrypted file lives in' do 
      context './roro/' do
        Given { decrypt['./roro/dummy.env.enc'] }

        Then { assert_file './roro/dummy.env' }
      end
      
      context './roro/env/' do
        Given { decrypt['./roro/env/dummy.env.enc'] }

        Then { assert_file './roro/env/dummy.env' }
      end

      context './roro/env/containers/database' do
        Given { decrypt['./roro/containers/database/env/dummy.env.enc'] }

        Then { assert_file './roro/containers/database/env/dummy.env' }
      end
    end
  end
  
  describe ':gather_environments' do
    Given(:gather_environments) { subject.gather_environments('./roro', ['.env', '.enc']) }
    Given(:args) { ['./roro', ['.env', '.enc']]  }
    
    context 'when .env file' do 
      
      Given { insert_file 'dummy_env', './roro/env/dummy.env' }
    
      Then { assert_equal gather_environments, ['dummy'] }
    end
    
    context 'when .env.enc file' do 
      
      Given { insert_file 'dummy_env', './roro/env/dummy.env.enc' }
    
      Then { assert_equal gather_environments, ['dummy'] }
    end 
  end
  
  describe ':generate_keys(environments, directory, extension' do
    Given { insert_file 'dummy_env', './roro/env/dummy.env' }
    
    context 'without nil environment' do 
      Given(:environments) { nil }
    
      Then { assert_equal subject.generate_keys(environments, './roro', '.env'), 'blah'} 
    end
  end
  
  describe ":obfuscate(key, directory, extension" do
    Given { insert_file 'dummy_env', './roro/env/dummy.env' }
    Given { insert_file 'dummy_key', './roro/keys/dummy.key' }
    
    context 'when called with key, directory, and extension arguments' do 
      context 'when all match' do 
        Given { subject.obfuscate('dummy', './roro/env', '.env') }
        
        Then  { assert_file './roro/env/dummy.env.enc' }
      end
      
      context 'when different key' do 
        Given { insert_file 'dummy_key', './roro/keys/production.key' }
        Given { subject.obfuscate('production', './roro/env', '.env') }
      
        Then  { assert_file './roro/env/dummy.env.enc' }
      end
      
      context 'when directory' do 
        Given { insert_file 'dummy_env', './roro/containers/app/dummy.env' }
        Given { subject.obfuscate(nil, './roro/containers/app', '.env') }
      
        describe 'must encrypt file in specified directory' do 
          Then  { assert_file './roro/containers/app/dummy.env.enc' }
        end 
        
        describe 'will not encrypt file in unspecified directory' do 
          Then  { refute_file './roro/env/dummy.env.enc' }
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
          
            Then  { assert_file './roro/env/production.env.enc' }
            And   { assert_file './roro/env/development.env.enc' }
            And   { assert_file './roro/env/test.env.enc' }
          end
        end 
        
        context 'when some .env files are subenvs' do
          Given { insert_file 'dummy_key', './roro/keys/staging.key' }
          Given { insert_file 'dummy_env', './roro/env/staging.sub.env.env' }
          Given { subject.obfuscate }
          
          Then  { assert_file './roro/env/staging.sub.env.env.enc' }
        end 
      end
    end
  end
end