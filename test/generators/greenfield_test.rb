require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }

  Given { prepare_destination 'greenfield' }

  describe "dependencies" do

    Given(:error) { Roro::Error }
    Given { FileUtils.rm('.keep') }

    describe "when not empty" do

      Given { FileUtils.touch("legacy_file.txt")  }

      Then { assert_raises( error ) { subject.greenfield } }
    end
  end

  describe "usage" do

    Given { subject.get_configuration_variables(test: true) }
    
    describe "must generate files" do
      describe '.copy_greenfield_to_host' do 
      
        Given { subject.copy_greenfield_files }
        
        Then do
          assert_file 'Dockerfile' do |c|
            assert_match 'bundle exec rails new .', c
          end          
        end
      end

      describe './greenfield' do 
        Given { skip }
        Given { subject.greenfield }
      
        Then do
          assert_file 'Dockerfile' do |c|
            assert_match 'bundle exec rails new greenfield', c
          end          
        end
      end
    end
  end
end
