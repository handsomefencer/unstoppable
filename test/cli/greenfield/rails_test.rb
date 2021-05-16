require "test_helper"

describe Roro::CLI do
  before { skip }
  Given { greenfield_rails_test_base }
  Given(:cli) { Roro::CLI.new}
  
  Given(:assert_roro_directories) { 
    assert_directory "roro"
    assert_directory "roro/keys"
    assert_directory "roro/containers"
    assert_directory "roro/containers/app"
  } 

  Given(:lines) { [ 'bundle exec rails new .', 'ruby:2.7' ] }
  Given(:file)  { 'roro/containers/app/Dockerfile' }

  Given(:assert_dockerfile) { assert_file(file, lines)  } 
  
  describe 'greenfield' do 

    Given { cli.greenfield }
    
    Then { assert_roro_directories }
    And  { assert_dockerfile }
  end    
      
  describe 'greenfield::rails' do 

    Given { cli.greenfield_rails }

    Then { assert_roro_directories }
    And  { assert_dockerfile }
  end    
end