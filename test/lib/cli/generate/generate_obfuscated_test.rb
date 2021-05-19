require 'test_helper'

describe "Roro::CLI #generate_obfuscated" do
  before(:all) do 
    prepare_destination 'crypto'
    Thor::Shell::Basic.any_instance.stubs(:ask).returns('y')  
  end

  Given(:cli)     { Roro::CLI.new }

  context 'when no environments supplied' do 
    Given(:generate) { cli.generate_obfuscated }
    
    context 'when no .env files and' do
      context 'when no key' do 

        Then  { assert_raises(Roro::Crypto::EnvironmentError) { generate } }
      end
      
      context 'when key' do
        Given { insert_key_file }

        Then  { assert_raises(Roro::Crypto::EnvironmentError) { generate } }
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
      Given { insert_dummy }
      Given { insert_key_file }
      Given { insert_dummy('./roro/stupid.env') }
      Given { insert_key_file('stupid.key') }
      Given { generate }

      Then  { assert_file './roro/dummy.env.enc' }
      And   { assert_file './roro/stupid.env.enc' }
    end
  end
end