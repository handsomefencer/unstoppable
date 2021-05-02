require 'test_helper'

describe "Roro::CLI #generate_obfuscated" do
  Given           { prepare_destination 'crypto' }
  Given(:asker)   { Thor::Shell::Basic.any_instance.stubs(:ask).returns('y') }
  Given(:cli)     { Roro::CLI.new }

  context 'when no environments supplied' do 
    Given(:generate) { cli.generate_obfuscated }
    
    context 'when no .env files and' do
      context 'when no key' do 
        
        Then  { assert_raises(Roro::Crypto::EncryptableError) { generate } }
      end
      
      context 'when key' do
        Given { insert_key_file }

        Then  { assert_raises(Roro::Crypto::EncryptableError) { generate } }
      end
    end 
    
    context 'when .env files and' do 
      Given { insert_dummy }
      
      context 'when no key' do 
        Then  { assert_raises(Roro::Crypto::KeyError) { generate } }
      end
      
      context 'when matching key' do
        Given { insert_key_file }
        Given { generate }
        
        Then  { assert_file './roro/dummy.env.enc'}
      end
    end
    
    context 'when multiple .env files and keys' do 
      Given { insert_dummy('smart') }
      Given { insert_dummy('stupid') }
      Given { insert_key_file('smart') }
      Given { insert_key_file('stupid') }
      Given { generate }
focus 
      Then  { 
      assert_file './roro/smart.env'
      assert_file './roro/stupid.env.enc'
      assert_file './roro/stupid.env'
      }
        # assert_file './roro/smart.env.enc'}
    end
  end 


  describe 'starting point with .env but no .env.enc files' do
    # Given { cli.generate_key }

    # Then { envs.each {|e| assert_file "roro/keys/#{e}.key" } }
    # And  { envs.each {|e| assert_file env_dir + "#{e}.env" } }
    # And  { envs.each {|e| refute_file env_dir + "#{e}.env.enc" } }
  end

  describe ":generate_obfuscated(environment)" do
    describe 'with a key and an env.env file for an env' do
      describe 'must only obfuscate the environment specified' do
        # Given { cli.generate_obfuscated 'production' }

        # Then { assert_file 'roro/containers/app/production.env.enc' }
        # And  { refute_file 'roro/containers/app/development.env.enc' }
      end
    end
  end

  describe ":generate_obfuscated" do
    describe 'all env keys and all files' do

      # Given { cli.generate_obfuscated }

      # Then { envs.each {|e| assert_file dotenv_dir + "#{e}.env.enc" } }
      # And { envs.each {|e| assert_file dotenv_dir + "#{e}.env" } }
    end
  end
end