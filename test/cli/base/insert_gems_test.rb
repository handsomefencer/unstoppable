require 'test_helper'

describe Roro::CLI do
  Given { prepare_destination "rails/603" }

  Given(:cli) { Roro::CLI.new } 
  
  describe 'insertions' do 
    describe '.insert_pg_gem_into_gemfile' do 
      
      Given { cli.insert_pg_gem_into_gemfile }
      Then do 
        assert_file 'Gemfile' do |c| 
          assert_match("gem 'pg'", c)
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