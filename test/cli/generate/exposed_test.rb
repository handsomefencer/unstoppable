require 'test_helper'

describe "Roro::CLI" do

  Given(:asker) { Thor::Shell::Basic.any_instance }
  Given { asker.stubs(:ask).returns('y') }
  Given(:cli) { Roro::CLI.new }
  Given { prepare_destination 'crypto' }
  
  Given { cli.generate_key }
  Given { cli.generate_obfuscated }
  
  describe ':generate_exposed' do
    Given { insert_file 'dummy_key', './roro/keys/production.key'}
    Given { insert_file 'dummy_env', './roro/env/production.env'}
    
    describe 'expose one environment' do 
      
      Given { cli.generate_exposed 'production' }
      
      Then  { assert_file 'roro/env/production.env' }
      # And   { refute_file 'roro/containers/app/development.env' }
    end
    
    describe 'expose all environments' do 

      Given { cli.generate_exposed }
      # Then  { envs.each {|e| assert_file dotenv_dir + "#{e}.env" } }
    end

    describe "with ENV_KEY" do

      Given(:passkey) { File.read(Dir.pwd + '/roro/keys/development.key').strip }
      Given { ENV['DEVELOPMENT_KEY'] = passkey }

      describe 'expose one environment' do 
        
        Given { cli.generate_exposed 'development' }
        
        # Then  { assert_file 'roro/containers/app/development.env' }
        # And   { refute_file 'roro/containers/app/production.env' }
      end
    end
  end
end
