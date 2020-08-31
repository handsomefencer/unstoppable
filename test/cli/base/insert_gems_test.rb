require 'test_helper'

describe Roro::CLI do
  Given { prepare_destination "rails/603/with_sqlite" }

  Given(:cli) { Roro::CLI.new } 
  
  describe 'insertions' do
    describe 'database gems' do 
      describe 'when legacy is' do 
        describe 'sqlite' do  
          
          Given { prepare_destination "rails/603/with_sqlite" }
          
          describe '.insert_db_gem(pg)' do 
            
            Given(:expected) { 'pg' }
            Given { cli.insert_db_gem(expected) }
        
            Then { assert_file( 'Gemfile' ) { |c| assert_match /#{expected}/, c } }  
            And  { assert_file( 'Gemfile' ) { |c| refute_match /mysql/, c } }  
            And  { assert_file( 'Gemfile' ) { |c| refute_match /sqlite/, c } }  
          end
          
          describe '.insert_db_gem(mysql2)' do 

            Given(:expected)   {'mysql2'}
            Given { cli.insert_db_gem(expected) }
        
            Then { assert_file( 'Gemfile' ) { |c| assert_match /#{expected}/, c } }  
            And  { assert_file( 'Gemfile' ) { |c| refute_match /pg/, c } }  
            And  { assert_file( 'Gemfile' ) { |c| refute_match /sqlite/, c } }  
          end
        end
        
        describe 'pg' do  
          
          Given { prepare_destination "rails/603/with_pg" }
          
          describe '.insert_db_gem(pg)' do 

            Given(:expected)   { 'pg' }
            Given { cli.insert_db_gem(expected) }
        
            Then { assert_file( 'Gemfile' ) { |c| assert_match /#{expected}/, c } }  
            And  { assert_file( 'Gemfile' ) { |c| refute_match /mysql/, c } }  
            And  { assert_file( 'Gemfile' ) { |c| refute_match /sqlite/, c } }  
          end
          
          describe '.insert_db_gem(mysql2)' do 

            Given { cli.insert_db_gem('mysql2') }
            Given(:expected)   {'mysql2'}
        
            Then { assert_file( 'Gemfile' ) { |c| assert_match /mysql2/, c } }  
            And  { assert_file( 'Gemfile' ) { |c| refute_match /pg/, c } }  
            And  { assert_file( 'Gemfile' ) { |c| refute_match /sqlite/, c } }  
          end
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