require 'test_helper'

describe Roro::CLI do
  Given { skip } #this is a smell, should probably be testing in okanomi }
  Given { rollon_rails_test_base }
  Given(:cli)    { Roro::CLI.new }
  Given(:rollon) { cli.rollon_rails  }
  Given(:config) { cli.instance_variable_get("@config" ) } 
  
  describe 'intentions' do
      
    Given(:roro) { "gem 'roro'" }
    Given(:hfci) { "gem 'handsome_fencer-test'" }
    
    describe 'yes' do
      Given { byebug } 
      Given { config.intentions[:insert_hfci_gem_into_gemfile] = 'y'}
      Given { config.intentions[:insert_roro_gem_into_gemfile] = 'y'}
      Given { rollon }
      
      Then { assert_file( 'Gemfile' ) { |c| assert_match(hfci, c) } }
      # And  { assert_file( 'Gemfile' ) { |c| assert_match(roro, c) } }
    end
      
    describe 'no' do 
      
      Given { config.intentions[:insert_hfci_gem_into_gemfile] = 'n'}
      Given { config.intentions[:insert_roro_gem_into_gemfile] = 'n'}
      Given { rollon }
      
      # Then { assert_file( 'Gemfile' ) { |c| refute_match(hfci, c) } }
      # And  { assert_file( 'Gemfile' ) { |c| refute_match(roro, c) } }
    end
    
    describe 'configures stdout' do 

      Given { rollon }
      Given(:file) { 'config/boot.rb' }
      Given(:insertion) { "$stdout.sync = true" }
      
      # Then { assert_insertion }
    end

    describe 'configures .gitignore' do 
      
      Given { rollon }
      Given(:file) { ".gitignore" }
      Given(:insertions) {["roro/**/*.env", "roro/**/*.key"] }
      
      # Then { assert_insertions } 
    end
    
    describe "adds or edits .dockerignore'" do 
      Given { rollon }
      # Then { assert_file ".dockerignore" }
    end
    
  end 
    
  describe 'actions' do

    Given { rollon }
    
    describe 'docker-entrypoint.sh' do 
      
      Given(:file) { 'roro/docker-entrypoint.sh' }
      Given(:insertions) {[
        "#!/bin/bash", 
        "rm -f /usr/src/app/tmp/pids/server.pid",
        "exec \"$@\""
      ] }
      
      Then { assert_insertions }
    end

    describe 'docker-compose.yml' do 
      
      Given(:file) { "docker-compose.yml" }
      Given(:insertions) {["version: '3.2", "  database:"] }
      
      Then { assert_insertions }
    end
    
    describe '.env file for docker-compose.yml' do 
      
      Given(:file) { ".env" }
      Given(:insertion) { 'RORO_ENV=development' } 

      Then { assert_insertion }
    end
          
    describe 'roro directories' do 

      Then { assert_directory "roro" }
      And  { assert_directory "roro/containers" }
      And  { assert_directory "roro/containers/app" } 
      And  { assert_directory "roro/containers/database" } 
      And  { assert_directory "roro/containers/frontend" } 
    end
        
    describe 'Dockerfile' do 
      
      Given(:file)       { "roro/containers/app/Dockerfile" }
      Given(:insertions) { [
        "FROM ruby:#{config.env['ruby_version']}",
        "maintainer=\"#{config.env['docker_email']}"
      ] } 

      # Then { assert_insertions }
    end 
    
    describe "must create .env file for roro environments" do 
      
      Given(:file) { "roro/containers/app/#{config.env[:env]}.env" }
      Given(:environments) { Roro::CLI.roro_environments }
      Given(:insertions) { ["DATABASE_HOST=#{config.env[:database_host]}"] }

      # Then { assert_insertions_in_environments }
    end 
  end
end 