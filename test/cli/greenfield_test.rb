require "test_helper"

describe Roro::CLI do
  
  Given { greenfield_rails_test_base }
  
  Given(:assert_roro_directories) { 
    assert_directory "roro"
    assert_directory "roro/containers"
    assert_directory "roro/containers/app"
  } 

  Given(:lines) { [ 'bundle exec rails new .', 'ruby:2.7' ] }
  Given(:file)  { 'roro/containers/app/Dockerfile' }

  Given(:assert_dockerfile) { assert_file(file, lines)  } 
  
  describe 'greenfield' do 

    Given { @cli.greenfield }
    
    describe 'roro directories' do 
      
      Then { assert_roro_directories }
    end
    
    describe 'roro/containers/app/Dockerfile' do
      
      Then { assert_dockerfile }
    end
  end
      
  describe 'greenfield::rails' do 
    
    Given { @cli.greenfield_rails }

    describe 'roro directories' do 
      
      Then { assert_roro_directories }
    end
    
    describe 'roro/containers/app/Dockerfile' do
      
      Then { assert_dockerfile }
    end
  end    
end