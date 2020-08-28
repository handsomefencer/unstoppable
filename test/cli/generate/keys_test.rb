require "test_helper"

describe Roro::CLI do
  Given { prepare_destination 'roro' }

  Given(:error) { Roro::Error }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given(:subject) { Roro::CLI.new }
  
  Given(:envs) { %w(development staging production) }
  Given(:dotenv_dir) { 'roro/containers/app/' }
  Given { insert_dot_env_files(envs) }
  Given(:dotenv_dir) { 'roro/containers/app/' }


  describe 'new roro directory must not have keys' do 
    
    Then do
      refute_file 'roro/keys/ci.key'
      refute_file 'roro/keys/production.key'
      refute_file 'roro/keys/staging.key'
      refute_file 'roro/keys/development.key' 
    end
  end
  
  describe "gather_environments" do

    Given(:actual) { subject.gather_environments }

    Then { envs.each { |env| assert_includes actual, env } }
  end
  
  describe 'generate_key' do
    describe 'with env specified' do 
      
      Given { subject.generate_key('ci') }
      
      describe 'must only generate the specified key' do 
        
        Then { assert_file 'roro/keys/ci.key' }
        And  { refute_file 'roro/keys/production.key' }
      end
    end
    
    describe 'without env specified' do 
      describe 'must generate key even without env.env files' do 
        Given(:env_with_no_env)  { 'no_dot_env_environment' }       
        Given { subject.generate_key env_with_no_env }

        Then { assert_file "roro/keys/#{env_with_no_env}.key" }
      end
      
      describe 'must generate keys when env.env exists' do 
        
        Given { subject.generate_key }
        
        Then { envs.each { |e| assert_file "roro/keys/#{e}.key" } }
      end
    end
  end

  describe '.confirm_files_decrypted()' do
    describe 'without either .env or .env.enc' do
      
      Then { assert subject.confirm_files_decrypted?('circleci') }
    end
    
    describe 'when just a .env file present' do 

      Given { subject.generate_key }
      
      Then { assert subject.confirm_files_decrypted?('circleci') }

      describe "when .env.enc file has no matching .env file" do
       
        Given { subject.generate_obfuscated }
        Given { remove_dot_env_files(['development']) }
        Given { refute_file 'roro/containers/app/development.env' }
        
        Then do
          assert_raises(error) {subject.confirm_files_decrypted? 'development'}
        end

        describe "when called from generate_key" do

          Then { assert_raises( error ) { subject.generate_key 'development' } }
        end

        describe "when called from generate_key" do

          Then { assert_raises( error ) { subject.generate_key } }
        end
      end
    end
  end
end