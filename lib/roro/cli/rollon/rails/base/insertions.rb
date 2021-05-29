
module Roro

  class CLI < Thor
    
    no_commands do 
          
      def config_std_out_true
        file = 'config/boot.rb'
        line = "$stdout.sync = true\n\n"
        prepend_to_file(file, line, force: true)
      end 
      
      def copy_dockerignore 
        copy_file 'base/.dockerignore', '.dockerignore'
      end 
      
      def gitignore_sensitive_files
        append_to_file ".gitignore", "\nroro/**/*.smart.env\nroro/**/*.key"
        append_to_file ".gitignore", "\nroro/**/*.smart.env\nroro/**/*.key"
        append_to_file ".gitignore", "\n*kubeconfig.yaml"
        append_to_file ".gitignore", "\n*kubeconfig.yml"
        append_to_file ".gitignore", "\n*.roro_configurator.yml"
      end
    end
  end 
end
