require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }
  Given { stub_system_calls }
  
  ['p', 'm'].each do |db|
    Given(:config) { Roro::Configuration.new }
    
    Given(:subject)     { Roro::CLI.new }
    Given(:rollon) { 
      subject.instance_variable_set(:@config, config)
      subject.rollon
    }
    
    Given { rollon }
    
    describe '.rollon' do 
      describe 'insertions' do
        describe 'only takes specified thor actions' do 
          
          Given(:hfci) { "gem 'handsome_fencer-test'" }
          Given(:roro) { "gem 'roro'" }
          Then { assert_file( 'Gemfile' ) { |c| 
            refute_match(hfci, c)
            assert_match(roro, c)
          }}
        end
        
        describe 'configures stdout' do 
            
          Given(:file) { 'config/boot.rb' }
          Given(:line) { "$stdout.sync = true" }
          
          Then { assert_file file { |c| assert_match(line, c ) } }
        end

        describe 'configures .gitignore' do 
          
          Given(:file) { ".gitignore" }
          Given(:lines) {["roro/**/*.env", "roro/**/*.key"] }
          
          Then { assert_file(file) { |c| lines.each { |l| assert_match l, c } }}
        end
      end 
        
      describe 'copies' do
          
        describe 'docker-entrypoint.sh' do 
          
          Then { assert_file 'roro/docker-entrypoint.sh' }
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
              Given(:line1) { "FROM ruby:#{config.app['ruby_version']}"} 
              Given(:line2) { "maintainer=\"#{config.app['dockerhub_email']}"} 
              Then { assert_file file}
              # Then { assert_file(file) { |c| 
                # assert_match line1, c 
                # assert_match line2, c 
              # }}
            end 
          end
        end
        
  #       # %w(development production test staging ci).each do |env| 
        
  #       #   describe "must create .env file for #{env}" do 
  #       #     Given(:line) { "DATABASE_HOST=#{config.app['database_host']}" }

  #       #     Then do 
  #       #       assert_file "roro/containers/app/#{env}.env" do |c| 
  #       #         assert_match line, c 
  #       #       end 
  #       #     end
  #       #   end
  #       # end 
      end
    end 
  end
end