require "test_helper"

describe Roro::CLI do
  
  Given { greenfield_rails_test_base }
  
  describe './greenfield' do 
     Given(:cli) { Roro::CLI.new }
    Given { cli.stubs(:rollon_rails) }
    Given { cli.greenfield( { story: :rails} ) }
    
    describe 'roro directories' do 

      Then { assert_directory "roro" }
      And  { assert_directory "roro/containers" }
      And  { assert_directory "roro/containers/app" } 
    end
    
    describe 'roro/containers/app/Dockerfile' do 

      Given(:lines) { [ 'bundle exec rails new .', 'ruby:2.7' ] }
      Given(:file)  { 'roro/containers/app/Dockerfile' }
      
      Then { assert_file(file) {|c| lines.each { |l| assert_match l, c } } }
    end
  end
end