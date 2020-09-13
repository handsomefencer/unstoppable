module Roro
  class CLI < Thor
        
    desc "rollon", "Rolls RoRo, a collection of files that allows you to run 
      your application in a containerized environment, optionally with CI/CD
      and everything necessary to deploy with Kubernetes."
    
    method_option :interactive, desc: "Set up your environment variables as 
      you go."
      
    def rollon(options={})
      configure_for_rollon(options)
      @config.structure[:actions].each {|a| eval a }
      execute_intentions
      startup_commands 
    end
    
    no_commands do 
     
      def configure_for_rollon(options=nil)
        @config ||= Roro::Configuration.new(options) 
      end

      def yaml_from_template(file)
        File.read(find_in_source_paths(file))
      end
      
      def execute_intentions 
        @config.intentions.each {|k, v|
           eval(k.to_s) if v.eql?('y') 
          }  
      end
      
      def generate_config_story 
      
      end
    end
  end
end