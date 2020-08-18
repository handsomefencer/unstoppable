
module Roro

  class CLI < Thor
    
    no_commands do 
          
      def insert_roro_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'roro'\n\n", before: "group :development, :test do"
      end
      
      def insert_db_gem(gem)
        %w(sqlite pg mysql2).each { |vendor| comment_lines 'Gemfile', vendor } 
        uncomment_lines 'Gemfile', gem
        insert_into_file 'Gemfile', "gem '#{gem}'", above: "group :development, :test do"
      end

      def insert_pg_gem_into_gemfile
        insert_db_gem('pg')
      end
      
      def insert_mysql2_gem_into_gemfile
        insert_db_gem('mysql2')
      end

      def insert_hfci_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'handsome_fencer-test'\n\n", after: "group :development, :test do"
      end  
    end
  end 
end
