
module Roro

  class CLI < Thor
    
    no_commands do 
          
      def config_std_out_true
        prepend_to_file('config/boot.rb', "$stdout.sync = true\n\n")
      end 
      
      def gitignore_sensitive_files
        append_to_file ".gitignore", "\nroro/**/*.env\nroro/**/*.key"
      end
    end
  end 
end
