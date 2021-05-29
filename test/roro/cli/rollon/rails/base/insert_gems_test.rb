require 'test_helper'

describe Roro::CLI do
  before { skip }
  Given { skip 
  rollon_rails_test_base }
  Given(:cli)  { Roro::CLI.new } 
  Given(:file) { 'Gemfile' }
  
  describe 'database gems' do 
    describe 'when legacy is' do 
      describe 'sqlite' do  
        
        # Given { prepare_destination "rails/603/with_sqlite" }
        
        describe '.insert_db_gem(pg)' do 
          
          Given(:insertion) { /pg/ }
          Given(:removals)  { [ /mysql/, /sqlite/ ] }
          
          When { cli.insert_db_gem(insertion) }

          Then {  
            assert_insertion } 
          And  { assert_removals }
        end
        
        describe '.insert_db_gem(mysql2)' do 

          Given(:insertion) { /mysql/ }
          Given(:removals)  { [ /pg/, /sqlite/ ] }
          
          When { cli.insert_db_gem(insertion) }

          Then { assert_insertion } 
          And  { assert_removals }
        end
      end
      
      describe 'pg' do  
        
        # Given { prepare_destination "rails/603/with_pg" }
        
        describe '.insert_db_gem(pg)' do 

          Given(:insertion) { /pg/ }
          Given(:removals)  { [ /mysql/, /sqlite/ ] }
          
          When { cli.insert_db_gem(insertion) }

          Then { assert_insertion } 
          And  { assert_removals }
        end
        
        describe '.insert_db_gem(mysql2)' do 

          Given(:insertion) { /mysql/ }
          Given(:removals)  { [ /pg/, /sqlite/ ] }
          
          When { cli.insert_db_gem(insertion) }

          Then { assert_insertion } 
          And  { assert_removals }        
        end
      end      
    end      
  end

  describe '.insert_roro_gem_into_gemfile' do 
    
    Given(:insertion) { "gem 'roro'" }
    
    When { cli.insert_roro_gem_into_gemfile }
    
    Then { assert_insertion }
  end

  describe '.insert_hfci_gem_into_gemfile' do 
    
    Given(:insertion) { "gem 'handsome_fencer-test'" } 
    
    When { cli.insert_hfci_gem_into_gemfile }
    
    Then { assert_insertion }
  end
end