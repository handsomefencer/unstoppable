module Roro
  class CLI < Thor
        
    desc "rollon", "Rolls RoRo, a collection of files that allows you to run 
      your application in a containerized environment, optionally with CI/CD
      and everything necessary to deploy with Kubernetes."
    
    method_option :interactive, desc: "Set up your environment variables as 
      you go."
      
    def rollon(options={})
      configure_for_rollon(options)
      manifest_actions
      manifest_intentions
      
      congratulations

      startup_commands 
    end
    
    no_commands do 
    
      def configure_for_rollon(options=nil)
        @config ||= Roro::Configuration.new(options) 
      end

      def manifest_actions
        @config.structure[:actions].each {|a| eval a }
      end
      
      def manifest_intentions
        @config.intentions.each {|k, v| eval(k.to_s) if v.eql?('y') }  
      end 
      
      def congratulations(story)
        ( @config.story[:rollon]) 
        if @config.structure[:greenfield]
          usecase = 'greenfielded a new '
        else 
          usecase = 'rolled your existing ' 
        end 
        # getsome = 
        array = ["You've successfully "]
        array << usecase
        # array << @config.story[:rollon]
        congrats = array.join("") 
        puts congrats
      end
      
      
      def startup_commands
        congratulations( @config.story[:rollon])
        cmd = @config.structure[:startup]
        commands = cmd[:commands] 
        question = []
        question << "\n\n You can start your app up with some combination of these commands:\n"
        commands.each { |c| question << "\t#{c}"}
        question << "\nOr if you'd like Roro to try and do it for you:"
        question = question.join("\n")
        if ask(question, default: 'y', limited_to: ['y', 'n']).eql?("y")
          commands.each {|a| system(a) }
          puts "\n\n#{cmd[:success]}\n\n" 
        end
      end
      
      def yaml_from_template(file)
        File.read(find_in_source_paths(file))
      end
      
      def generate_config_story
        roro_story = {
          story: @config.story,
          env_vars: @config.env,
          intentions: @config.intentions
        }
        create_file ".roro_story.yml", roro_story.to_yaml 
      end
    end
  end
end