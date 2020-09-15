module Roro
  class CLI < Thor
   
    class_option :fatsutofodo, { desc: 'Uses the Roro setup but will not try to 
      help you customize any files.', aliases: ['--fast', '-f']}
    class_option :omakase,     { desc: "Uses the Roro setup. 'Omakase' is a 
        Japanese phrase that means 'I'll leave it up to you.'", default: true}
    class_option :okonomi,     { desc: "You choose what you like. 'Okonomi' 
          has the opposite meaning of omkakase", aliases: ['-i', '--interactive'] }
 
    desc "rollon", "Roll an existing app."
  
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
      
      def congratulations(story=nil)
        ( @config.story[:rollon]) 
        if @config.structure[:greenfield]
          usecase = 'greenfielded a new '
        else 
          usecase = 'rolled your existing ' 
        end 
        array = ["You've successfully "]
        array << usecase
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