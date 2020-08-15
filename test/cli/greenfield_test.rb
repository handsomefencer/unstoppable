require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination 'greenfield' }
  
  describe "usage" do
    describe "must generate files" do
      describe '.copy_greenfield_to_host' do 
      
        Given { subject.configure_for_greenfielding }
        Given { subject.copy_greenfield_files }
        
        Then do
          lines = [
            'bundle exec rails new .',
            'ruby:2.7'
          ]
          lines.each do |line| 
            assert_file 'Dockerfile' do |c|
              assert_match line, c
            end          
          end
        end
      end

      describe './greenfield' do 

        Given { subject.expects(:system).times(1..20) }
        Given { subject.expects(:rollon).returns(true) }
        Given { subject.greenfield }
      
        Then do
          assert_file 'Dockerfile' do |c|
            assert_match 'bundle exec rails new ', c
          end          
        end
      end
    end
  end
end
