
module Roro

  class CLI < Thor
    
    no_commands do 
          
      def insert_roro_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'roro'\n\n", before: "group :development, :test do"
      end
      
      def insert_db_gem(gem)
        gem_lines = [
          /gem\s['"]sqlite3['"]/,
          /gem\s['"]mysql2['"]/,
          /gem\s['"]pg['"]/,
          
        ]
        gem_lines.each do |line| 
          comment_lines 'Gemfile', line 
          gsub_file 'Gemfile', line, 'gem copied over by roro'
        end
        insert_into_file 'Gemfile', "gem '#{gem}'\n\n", before: "group :development, :test"
      end

      def insert_hfci_gem_into_gemfile
        insert_into_file 'Gemfile', "gem 'handsome_fencer-test'\n\n", after: "group :development, :test do"
      end  
    end
  end 
end
