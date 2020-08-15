require 'test_helper'

describe Roro::CLI do

  Given { prepare_destination 'rails/603' }

  describe '.rollon' do 
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
      
        Given { subject.copy_roro_files }
      
        describe 'copies root files' do 
          describe 'dotfiles' do 
      
            Then { assert_file ".dockerignore" }
          end
      
          describe 'copies directories' do 
      
            Then { assert_directory "roro" }
            And  { assert_directory "roro/containers" }
            And  { assert_directory "roro/containers/app" } 
            And  { assert_directory "roro/containers/database" } 
            And  { assert_directory "roro/containers/frontend" } 
          end
          
          describe 'copies containers' do 
            describe 'app' do 
              describe 'Dockerfile' do 
    
                Given(:expected) { [
                    "FROM ruby:#{config.app['ruby_version']}",
                    "maintainer=\"#{config.app[:dockerhub_email]}" ] }
        
                Then do 
                  expected.each do |line|
                    assert_file "roro/containers/app/Dockerfile" do |c| 
                      assert_match line, c
                    end
                  end
                end
              end 
            end
          end 
        end 
      end
      
      describe 'docker-compose.yml' do
        # Given { skip }
        
        Then do 
          [
            "version: '3.2",
            [
              "  database:",
              "    image: postgres",
              "    env_file:",
              "      - roro/containers/database/development.env",
              "    volumes:",
              "      - db_data:/var/lib/postgresql/data"
            ].join("\n"),
          ].each do |line| 
            assert_file "docker-compose.yml" 
            # do |c| 
            #   assert_match line, c
            # end
          end
        end
      end
    end    
  end
end