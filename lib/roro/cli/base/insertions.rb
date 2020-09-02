
module Roro

  class CLI < Thor
    
    no_commands do 
          
      def config_std_out_true
        file = 'config/boot.rb'
        line = "$stdout.sync = true\n\n"
        prepend_to_file(file, line, force: true)
      end 
      
      def gitignore_sensitive_files
        append_to_file ".gitignore", "\nroro/**/*.env\nroro/**/*.key"
        append_to_file ".gitignore", "\nroro/**/*.env\nroro/**/*.key"
        append_to_file ".gitignore", "\n*kubeconfig.yaml"
        append_to_file ".gitignore", "\n*kubeconfig.yml"
      end
    end
  end 
end
