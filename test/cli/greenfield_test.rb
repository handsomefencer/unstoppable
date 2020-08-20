require "test_helper"

describe Roro::CLI do

  Given { IO.stubs(:popen).returns([])}  
  Given { stub_system_calls }

  Given(:subject) { Roro::CLI.new }

  Given { prepare_destination 'greenfield' }
  describe "usage" do
    describe "must generate files" do
      describe '.copy_greenfield_to_host' do 
      
        Given { subject.configure_for_greenfielding }
        Given { subject.copy_greenfield_files }

        describe 'must have a docker-compose file to create volumes' do 
          
          Then { assert_file 'docker-compose.yml' }
        end
         
        describe 'must have rails new line' do 
          Then do
            ['bundle exec rails new .','ruby:2.7'
            ].each do |line| 
              assert_file 'Dockerfile' do |c|
                assert_match line, c
              end          
            end
          end
        end
      end
      
      describe './greenfield' do 

        Given { subject.expects(:system).times(1..20) }
        Given { subject.expects(:rollon).returns(true) }
        Given { subject.greenfield }
        Given(:expected_line) { 'bundle exec rails new ' }
        
        Then { assert_file('Dockerfile') {|c| assert_match expected_line, c } }
      end
    end
  end
end
