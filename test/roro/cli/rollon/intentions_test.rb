require 'test_helper'

describe Roro::CLI do
  Given { skip }
  
  ## these tests seem redundant or misplaced at the moment. Maybe use 
  ## .roro_story.yml files to test the same things?
  Given { rollon_rails_test_base }
  Given(:cli)    { Roro::CLI.new }
  Given(:rollon) { cli.rollon_rails  }
  Given(:config) { cli.instance_variable_get("@config" ) } 
  
  describe 'intentions' do
      
    Given(:roro) { "gem 'roro'" }
    Given(:hfci) { "gem 'handsome_fencer-test'" }
    
    describe 'yes' do

      Given { config.intentions[:insert_hfci_gem_into_gemfile] = 'y'}
      Given { config.intentions[:insert_roro_gem_into_gemfile] = 'y'}
      Given { rollon }
      
      # Then { assert_file( 'Gemfile' ) { |c| assert_match(hfci, c) } }
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
      Given(:insertions) {["roro/**/*.smart.env", "roro/**/*.key"] }
      
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
        "rm -f /usr/src/backend/tmp/pids/server.pid",
        "exec \"$@\""
      ] }
      
      # Then { assert_insertions }
    end

    describe 'preface-returns-array_of_strings.yml' do
      
      Given(:file) { "preface-returns-array_of_strings.yml" }
      Given(:insertions) {["version: '3.2", "  database:"] }
      
      # Then { assert_insertions }
    end
    
    describe '.smart.env file for preface-returns-array_of_strings.yml' do
      
      Given(:file) { ".smart.env" }
      Given(:insertion) { 'RORO_ENV=development' } 

      # Then { assert_insertion }
    end
          
    describe 'roro directories' do

      # Then { assert_directory "roro" }
      # And  { assert_directory "roro/containers" }
      # And  { assert_directory "roro/containers/backend" }
      # And  { assert_directory "roro/containers/database" }
      # And  { assert_directory "roro/containers/frontend" }
    end
        
    describe 'Dockerfile' do 
      
      Given(:file)       { "roro/containers/backend/Dockerfile" }
      Given(:insertions) { [
        "FROM ruby:#{config.env['ruby_version']}",
        "maintainer=\"#{config.env['docker_email']}"
      ] } 

      # Then { assert_insertions }
    end 
    
    describe "must create .smart.env file for roro environments" do
      
      Given(:file) { "roro/containers/backend/#{config.env[:env]}.smart.env" }
      Given(:environments) { Roro::CLI.roro_environments }
      Given(:insertions) { ["DATABASE_HOST=#{config.env[:database_host]}"] }

      # Then { assert_insertions_in_environments }
    end 
  end
end 