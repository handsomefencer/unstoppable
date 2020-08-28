require 'test_helper'

describe "Roro::CLI" do
  Given { prepare_destination 'roro' }
  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given(:subject) { Roro::CLI.new }

  Given(:envs) { %w(development staging production) }
  Given { insert_dot_env_files(envs) }
  Given(:dotenv_dir) { 'roro/containers/app/' }
  Given { subject.generate_key }
     
  describe 'starting point with .env but no .env.enc files' do
    
    Then { envs.each {|e| assert_file "roro/keys/#{e}.key" } }
    And  { envs.each {|e| assert_file dotenv_dir + "#{e}.env" } }
    And  { envs.each {|e| refute_file dotenv_dir + "#{e}.env.enc" } }
  end
  
  describe ":generate_obfuscated(environment)" do
    describe 'with a key and an env.env file for an env' do 
      describe 'must only obfuscate the environment specified' do 
        Given { subject.generate_obfuscated 'production' }
        
        Then { assert_file 'roro/containers/app/production.env.enc' }
        And  { refute_file 'roro/containers/app/development.env.enc' }
      end
    end
  end

  describe ":generate_obfuscated" do
    describe 'all env keys and all files' do 
    
      Given { subject.generate_obfuscated }
      
      Then { envs.each {|e| assert_file dotenv_dir + "#{e}.env.enc" } }
      And { envs.each {|e| assert_file dotenv_dir + "#{e}.env" } }
    end
  end
end