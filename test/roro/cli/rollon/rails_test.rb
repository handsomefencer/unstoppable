require 'test_helper'

describe Roro::CLI do
  before { skip }
  Given { rollon_rails_test_base }
  Given(:cli) { Roro::CLI.new }
  Given(:rollon) { cli.rollon }
  Given(:config) { cli.instance_variable_get("@config" ) } 
  
  Given { rollon }

  describe 'actions' do
    describe 'docker-entrypoint.sh' do 
      
      Given(:file) { 'roro/docker-entrypoint.sh' }
      Given(:insertions) {[
        "#!/bin/bash", 
        "rm -f /usr/src/backend/tmp/pids/server.pid",
        "exec \"$@\""
      ] }
      
      Then { assert_insertions }
    end

    describe 'preface-returns-array.yml' do
      
      Given(:file)       { "preface-returns-array.yml" }
      Given(:insertions) { [ "version: '3.2", "  database:" ] }
      
      Then { assert_insertions }
    end
    
    describe '.smart.env file for preface-returns-array.yml' do
      
      Given(:file) { ".smart.env" }
      Given(:insertion) { 'RORO_ENV=development' } 

      Then { assert_insertion }
    end
          
    describe 'roro directories' do

      Then { assert_directory "roro" }
      And  { assert_directory "roro/containers" }
      And  { assert_directory "roro/containers/backend" }
      And  { assert_directory "roro/containers/database" }
      And  { assert_directory "roro/containers/frontend" }
    end
        
    describe 'Dockerfile' do 
      
      Given(:file)       { "roro/containers/backend/Dockerfile" }
      Given(:insertions) { [
        "FROM ruby:#{config.env['ruby_version']}",
        "maintainer=\"#{config.env['docker_email']}"
      ] } 

      Then { assert_insertions }
    end 
    
    describe "must create .smart.env file for roro environments" do
      
      Given(:file) { "roro/containers/backend/#{config.env[:env]}.smart.env" }
      Given(:environments) { Roro::CLI.roro_environments }
      Given(:insertions) { ["DATABASE_HOST=#{config.env[:database_host]}"] }

      Then { assert_insertions_in_environments }
    end 
  end
end 