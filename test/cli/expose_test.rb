require 'test_helper'

describe "Roro::CLI" do

  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination 'roro' }
  
  Given(:dotenv_dir) { 'roro/containers/app/' }
  Given(:envs) { %w(development staging production) }
  Given { insert_dot_env_files(envs) }
  Given { subject.generate_keys }
  Given { subject.obfuscate }
  
  describe 'starting point' do 

    Then { envs.each {|e| assert_file "roro/keys/#{e}.key" } }
    And  { envs.each {|e| assert_file dotenv_dir + "#{e}.env" } }
    And  { envs.each {|e| assert_file dotenv_dir + "#{e}.env.enc" } }
  end
  
  describe '.expose' do
    
    Given { remove_dot_env_files(envs) }
    
    Then  { envs.each {|e| refute_file dotenv_dir + "#{e}.env" } }
    
    describe "with key_file" do
      describe 'expose one environment' do 
        
        Given { subject.expose 'production' }
        
        Then  { assert_file 'roro/containers/app/production.env' }
        And   { refute_file 'roro/containers/app/development.env' }
      end
      
      describe 'expose all environments' do 

        Given { subject.expose }
        Then  { envs.each {|e| assert_file dotenv_dir + "#{e}.env" } }
      end
    end

    describe "with ENV_KEY" do

      Given(:passkey) { File.read(Dir.pwd + '/roro/keys/development.key').strip }
      Given { ENV['DEVELOPMENT_KEY'] = passkey }

      describe 'expose one environment' do 
        
        Given { subject.expose 'development' }
        
        Then  { assert_file 'roro/containers/app/development.env' }
        And   { refute_file 'roro/containers/app/production.env' }
      end
    end
  end
end
