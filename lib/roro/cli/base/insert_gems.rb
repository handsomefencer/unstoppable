
module Roro

  class CLI < Thor
    
    no_commands do 
          
      def insert_roro_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'roro'\n\n", before: "group :development, :test do"
      end

      def insert_pg_gem_into_gemfile
        comment_lines 'Gemfile', /sqlite/
        comment_lines 'Gemfile', /mysql/
        insert_into_file 'Gemfile', "gem 'pg'\n\n", before: "group :development, :test do"
      end

      def insert_mysql_gem_into_gemfile
        comment_lines 'Gemfile', /sqlite/
        comment_lines 'Gemfile', /pg/
        insert_into_file 'Gemfile', "gem 'mysql2'\n\n", before: "group :development, :test do"
      end

      def insert_hfci_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'handsome_fencer-test'\n\n", after: "group :development, :test do"
      end  
    end
  end 
end
