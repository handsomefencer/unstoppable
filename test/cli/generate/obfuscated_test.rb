require 'test_helper'

describe "Roro::CLI #generate_obfuscated" do
  Given           { prepare_destination 'roro' }
  Given(:env_dir) { 'roro/containers/app/' }
  Given(:asker)   { Thor::Shell::Basic.any_instance.stubs(:ask).returns('y') }
  Given(:cli)     { Roro::CLI.new }

  Given(:envs) { %w(development staging production) }

  context 'when no .env files' do
Given { skip }
    Then  { assert_raises(Roro::Error) { cli.generate_obfuscated } }
  end

  context 'when .env file but no key' do
    Given { skip }
    Given { insert_dotenv('roro/containers/database/env/test.1.env') }

    Then  { assert_raises(Roro::Error) { cli.generate_obfuscated } }
  end

  context 'when .env file and same key' do
    Given { insert_dotenv('roro/containers/database/env/test.1.env') }
    Given { cli.generate_key('test')}
    Given { cli.generate_obfuscated }
    Then  { assert_file 'roro/containers/database/test.1.env.enc'  }
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