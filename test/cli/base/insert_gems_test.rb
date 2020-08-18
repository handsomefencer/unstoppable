require 'test_helper'

describe Roro::CLI do
  Given { prepare_destination "rails/603" }

  Given(:cli) { Roro::CLI.new } 
  
  describe 'insertions' do
    
    describe 'database gems' do 
      describe '.insert_db_gem()' do 
        
        Given { cli.insert_db_gem('pg') }
        
        describe 'other vendor gems must be commented out' do 

          # Then { assert_file( 'Gemfile' ) { |c| 
            # assert_match /# gem\s['"]mysql2['"]/, c
            # assert_match /# gem\s['"]sqlite3['"]/, c } }
        end 
        
        describe 'pg must be present and not commented' do 
          
          Then { assert_file( 'Gemfile' ) {|c| 
            assert_match /gem\s['"]pg['"]/, c
            # refute_match /# gem\s['"]pg['"]/, c 
            } }
        end
      end      
    end


    describe '.insert_roro_gem_into_gemfile' do 
      
      Given { cli.insert_roro_gem_into_gemfile }
      Then do 
        assert_file 'Gemfile' do |c| 
          assert_match("gem 'roro'", c)
        end
      end
    end

    describe '.insert_hfci_gem_into_gemfile' do 
      
      Given { cli.insert_hfci_gem_into_gemfile }
      
      Then do 
        assert_file 'Gemfile' do |c| 
          assert_match("gem 'handsome_fencer-test'", c)
        end
      end
    end
  end
end