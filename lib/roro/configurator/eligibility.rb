require 'open3'

module Roro
  module Configurator
    module Eligibility  
      
      def screen_target_directory
        options[:greenfield] ? confirm_directory_empty : confirm_directory_app
        handle_roro_artifacts
      end
     
      def confirm_directory_app 
        confirm_dependency({
          system_query: "ls -A",
          warning: "This is an empty directory. You can generate a new and fully 
            dockerized Rails app using the 'greenfield' command here here but if 
            you want to containerize an existing app -- which is what the 'rollon'
            command is for -- you'll need to navigate to a directory with an app we
            can roll onto.",
          suggestion: "$ roro greenfield",
          conditional: "!Dir.glob('*').empty?"})
      end
      
      def confirm_directory_empty 
        confirm = confirm_dependency({
          system_query: "ls -A",
          warning: "this is not an empty directory. Roro will not greenfield a new Rails app unless either a) the current directory is empty or b) you run greenfield with the --force flag",
          suggestion: "$ roro greenfield --force",
          conditional: "Dir.glob('*').empty?" # || (Dir.glob('*').size.eql?(1) && Dir.glob('roro_configurator.yml'))" 
          }) 
        confirm || true
      end

      def artifacts?
        @appname = @env[:main_app_name]
        @artifacts = {}
        hash = {
          containers: {
            list: "docker ps --filter name=#{@appname}\ -a",
            remove: " -q | xargs docker stop | xargs docker rm -f"
          }, 
          volumes: {
            list: "docker volume ls --filter name=#{@appname}*",
            remove: " -q | xargs docker volume rm -f"
          },
          networks: {
            list: "docker network ls --filter name=#{@appname}",
            remove: " -q | xargs docker network rm"
          },
          images: {
            list: "docker image ls #{@appname}*",
            remove: " -q | xargs docker rmi -f"
          }
        }
        hash.each do |k, v|
          check = IO.popen(v[:list] + ' -q').count > 0
          @artifacts[k] = v if check
        end
        true if @artifacts.empty?
      end
      
      def handle_roro_artifacts
        return if artifacts?
        question = [
          "\n\nThis machine has some docker artifacts which may clash with ",
          "RoRo moving forward. You can verify their existence with:\n"
        ]
        @artifacts.each { |k,v| question << "\t$ #{v[:list]}" } 
        question << "\nYou can remove these artifacts with something like:\n" 
        @artifacts.each { |k,v| question << "\t$ #{v[:list]} #{v[:remove]}" }
        question << "\nWould you like RoRo to attempt to remove them for you?"
        choices = {'y' => 'Yes', 'n' => 'No'}
        
        choices.each { |k,v| question << "(#{k}) #{v.to_s}" }
        
        prompt = question.join
        answer = ask(prompt, default: 'y', limited_to: choices.keys)
        
        if answer.eql?('y')
          
          @artifacts.each do |k,v| 
            puts "Attempting to remove #{k}"  
            system( v[:list] + v[:remove] )
          end 
        end
      end
      
      def confirm_dependency(options)
        msg = []
        msg << ""
        msg << delineator
        msg << "It looks like #{options[:warning]}. The following bash command returns false:"
        msg << "\t$ #{options[:system_query]}"
        msg << "Try this:"
        msg << ("\t" + options[:suggestion])
        msg << delineator
        conditional = options[:conditional] ? eval(options[:conditional]) : system(options[:system_query])
        query = options[:system_query]
        if conditional == false
          raise(Roro::Error.new(msg.join("\n\n")))
        else 
          true 
        end    
      end
      
      def confirm_dependencies
        dependencies.each do |dependency|
          confirm_dependency(dependency)
        end
      end
      
      private 
      
      def delineator
        ("-" * 80)
      end
      
      def dependencies
        [ { system_query: "which docker",
            warning: "Docker isn't installed",
            suggestion: "https://docs.docker.com/install/"
          }, {
            system_query: "which docker-compose",
            warning: "Docker Compose isn't installed",
            suggestion: "https://docs.docker.com/compose/install/"
          }, {
            system_query: "docker info",
            warning: "the Docker daemon isn't running",
            suggestion: "https://docs.docker.com/config/daemon/#start-the-daemon-manually"
        } ]
      end 
    end
  end 
end