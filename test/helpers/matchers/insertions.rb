module TestHelper
  module Matchers 
    module Insertions
      
      def assert_insertion 
        assert_file(file) { |c| assert_match( insertion, c ) } 
      end
      
      def assert_insertions 
        insertions.each { |l| assert_file(file) { |c| assert_match(l,c)}}
      end
      
      def assert_insertions_in_environments
        environments.each { |env| 
          config.env[:env] = env
          insertions.each { |insertion| 
            assert_file(file) { |c| 
              assert_match(insertion,c)
            }
          }
        }
      end
      
      
      def assert_removals 
        removals.each { |l| assert_file(file) { |c| refute_match(l,c)}}
      end
    end 
  end
end