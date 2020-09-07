require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }
  Given { stub_dependency_responses }
  Given(:cli)     { Roro::CLI.new }
  Given(:config) { Roro::Configurator.new() }
  Given(:rollon) { 
    cli.instance_variable_set(:@config, config)
    cli.rollon_rails
  }
  
  ['p', 'm'].each do |db|
    
    describe '.rollon_rails' do 
      describe 'insertions' do
        describe 'only takes specified thor actions' do 
          
          Given(:roro) { "gem 'roro'" }
          Given(:hfci) { "gem 'handsome_fencer-test'" }
          
          describe 'yes' do 
            
            Given { config.intentions[:insert_hfci_gem_into_gemfile] = 'y'}
            Given { config.intentions[:insert_roro_gem_into_gemfile] = 'y'}
            Given { rollon }
            
            Then { assert_file( 'Gemfile' ) { |c| assert_match(hfci, c) } }
            And  { assert_file( 'Gemfile' ) { |c| assert_match(roro, c) } }
          end
          
          describe 'no' do 
            
            Given { config.intentions['insert_hfci_gem_into_gemfile'] = 'n'}
            Given { config.intentions['insert_roro_gem_into_gemfile'] = 'n'}
            Given { rollon }
            
            Then { assert_file( 'Gemfile' ) { |c| refute_match(hfci, c) } }
            And  { assert_file( 'Gemfile' ) { |c| refute_match(roro, c) } }
          end
        end
        
        describe 'configures stdout' do 
  
          Given { rollon }
          Given(:file) { 'config/boot.rb' }
          Given(:line) { "$stdout.sync = true" }
          
          Then { assert_file file { |c| assert_match(line, c ) } }
        end

        describe 'configures .gitignore' do 
          
          Given { rollon }
          Given(:file) { ".gitignore" }
          Given(:lines) {["roro/**/*.env", "roro/**/*.key"] }
          
          Then { assert_file(file) { |c| lines.each { |l| assert_match l, c } }}
        end
      end 
        
      describe 'copies' do
  
        Given { rollon }
        describe 'docker-entrypoint.sh' do 
          
          Given(:file) { 'roro/docker-entrypoint.sh' }
          Given(:lines) {[
            "#!/bin/bash", 
            "rm -f /usr/src/app/tmp/pids/server.pid",
            "exec \"$@\""
          ] }
          
          Then { assert_file(file) { |c| lines.each { |l| assert_match l, c } }}
        end

        describe 'docker-compose.yml' do 
          
          Given(:file) { "docker-compose.yml" }
          Given(:lines) {["version: '3.2", "  database:"] }

          Then { assert_file(file) {|c| lines.each {|l| assert_match l, c}}}
        end
        
        describe '.env file for docker-compose.yml' do 
          
          Given(:file) { ".env" }
          Given(:line) { 'RORO_ENV=development' } 

          Then { assert_file(file) {|c| assert_match line, c}}
        end

        describe "'.dockerignore'" do 
    
          Then { assert_file ".dockerignore" }
        end
              
        describe 'roro directories' do 
    
          Then { assert_directory "roro" }
          And  { assert_directory "roro/containers" }
          And  { assert_directory "roro/containers/app" } 
          And  { assert_directory "roro/containers/database" } 
          And  { assert_directory "roro/containers/frontend" } 
        end
            
        describe 'containers' do 
          describe 'app' do 
            describe 'Dockerfile' do 
              
              Given(:file) { "roro/containers/app/Dockerfile" }
              Given(:line1) { "FROM ruby:#{config.env['ruby_version']}"} 
              Given(:line2) { "maintainer=\"#{config.env['docker_email']}"} 
    
              Then { assert_file(file) { |c| 
                assert_match line1, c 
                assert_match line2, c 
              }}
            end 
          end
        end
        
        %w(development production test staging ci).each do |env| 
        
          describe "must create .env file for #{env}" do 
            Given(:line) { "DATABASE_HOST=#{config.env['database_host']}" }

            Then do 
              assert_file "roro/containers/app/#{env}.env" do |c| 
                assert_match line, c 
              end 
            end
          end
        end 
      end
    end 
  end
end