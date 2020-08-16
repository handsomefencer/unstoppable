require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }

  describe '.rollon' do 
    ['m', 'p'].each do |db|
      Given { config.thor_actions['configure_database'] = db }

      describe 'without .roro_config.yml' do 
      
        Given(:subject) { Roro::CLI.new } 
        Given(:config) { subject.configure_for_rollon }
        Given { config }
        
        describe '.configure_for_rollon' do 
          
          Then { 
            assert_equal config.class, Roro::Configuration
            assert_equal config.choices.class, Hash 
            assert_equal config.app.class, Hash 
            assert_equal config.thor_actions.class, Hash 
            assert_equal config.master.class, Hash
          }
        end 
        
        
        describe '.copy_roro_files' do
          Given { config.thor_actions['insert_hfci_gem_into_gemfile'] = 'y'}
          Given { subject.copy_roro_files }
          
          describe 'insertions' do 
            describe '.insert_hfci_gem_into_gemfile' do 
              Then do 
                assert_file 'Gemfile' do |c| 
                  assert_match("gem 'handsome_fencer-test'", c)
                end
              end
            end 
            
            describe '.insert_roro_gem_into_gemfile' do 
              Given { skip }              
              Then do 
                assert_file 'Gemfile' do |c| 
                  assert_match("gem 'roro'", c)
                end
              end
            end
        
            
            Given(:file) { 'config/boot.rb' }
            Given(:line) { "$stdout.sync = true" }
            
            Then do 
              assert_file file do |c| 
                assert_match(line, c ) 
              end 
            end 
          end
            
          describe "'.gitignore'" do 
            Given(:file) { ".gitignore" }
            Given(:lines) {["roro/**/*.env", "roro/**/*.key"] }
            
            Then do 
              assert_file file do |c| 
                lines.each { |l| assert_match l, c } 
              end 
            end 
          end

          describe 'copies' do 
            describe 'docker-compose.yml' do 
              Given(:file) { "docker-compose.yml" }
              Given(:lines) {["version: '3.2", "  database:"] }

              Then { assert_file(file) {|c| lines.each {|l| assert_match l, c}}}
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
      
                  Given(:expected) { [
                      "FROM ruby:#{config.app['ruby_version']}",
                      "maintainer=\"#{config.app['dockerhub_email']}" ] }
          
                  Then do 
                    assert_file("roro/containers/app/Dockerfile") do |c| 
                      expected.each { |l| assert_match l, c }
                    end 
                  end
                end 
              end
              
              %w(development production test staging ci).each do |env| 
              
                describe "must create .env file for #{env}" do 
Given { skip }
                  Given(:expected) { "DATABASE_HOST=#{config.app['database_host']}" }

                  Then do 
                    assert_file "roro/containers/app/#{env}.env" do |c| 
                      assert_match expected, c 
                    end 
                  end
                end
              end 
            end
          end 
        end
      end    
    end
  end
end