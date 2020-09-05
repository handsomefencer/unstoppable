module Roro

  class CLI < Thor

    no_commands do
     
      def confirm_directory_not_empty 
        confirm_dependency({
          system_query: "ls -A",
          warning: "This is an empty directory. You can generate a new and fully 
            dockerized Rails app using the 'greenfield' command here here but if 
            you want to containerize an existing app -- which is what the 'rollon'
            command is for -- you'll need to navigate to a directory with an app we
            can roll onto.",
          suggestion: "$ roro greenfield",
          conditional: "!Dir.glob('*').empty? || (Dir.glob('*').size.eql?(1) && !Dir.glob('roro_configurator.yml'))" })
      end
      
      def confirm_directory_empty 
        confirm = confirm_dependency({
          system_query: "ls -A",
          warning: "this is not an empty directory. Roro will not greenfield a new Rails app unless either a) the current directory is empty or b) you run greenfield with the --force flag",
          suggestion: "$ roro greenfield --force",
          conditional: "Dir.glob('*').empty? || (Dir.glob('*').size.eql?(1) && Dir.glob('roro_configurator.yml'))" }) 
        confirm || true
      end
          
      def remove_roro_artifacts 
        appname = Dir.pwd.split('/').last 
        volumes = ["#{appname}_db_data", "#{appname}_app"]
        check_vol = "docker volume ls --filter name="
        # check_vols = volumes.each do |volume| 
        #   check = (IO.popen(check_vol + volume).count > (0))
        #   if check ? (return true) : false  
        # end
        
        # check_containers = "docker ps --filter name=#{appname}* -aq"
        
        # remove_containers = "docker ps --filter name=#{appname}* -aq | xargs docker stop | xargs docker rm"
        # byebug
        # return unless (check_containers || check_vols)
        # question = [
        #   "\n\nWe found some docker artifacts which may clash",
        #   "with RoRo moving forward. You can verify their existence in a ",
        #   "separate terminal with:"
        # ]
        # #   question << "\n\t$ #{check_containers}" if artifact_containers 
        # #   question << "\n\t$ #{check_vol + app_name + '*'}" if artifact_volumes 
        # #   question << "You can remove these artifacts with something like:\n" 
        # #   question << "\n\t$ #{remove_containers}" if artifact_containers 
        # #   if artifact_volumes
        # #     volumes.each do |v| 
        # #       check = (IO.popen(check_vol + volume).count > (0))
        # #       (question << "\n\t$ #{check_vol + app_name + '*'}") if check
        # #     end
        # #   end
        # #   question << "\nWould you like RoRo to attempt to remove them for you?"
        # #   question = question.join("\n")
        # #   prompt = [question]
        # #   choices = {'y' => 'Yes', 'n' => 'No'}
        #   # choices.each { |k,v| prompt << "(#{k}) #{v.to_s}" }
        #   # answer = ask((prompt.join("\n\n") + "\n\n"), 
        #   # default: 'y', limited_to: choices.keys)
        # end
      end
      
      def confirm_dependency(options)
        msg = []
        msg << ""
        msg << delineator
        msg << "It looks like #{options[:warning]}. The following bash command returns false:"
        msg << "\t$ #{options[:system_query]}"
        msg << "Please try these instructions:"
        msg << ("\t" + options[:suggestion])
        msg << delineator
        conditional = options[:conditional] ? eval(options[:conditional]) : system(options[:system_query])
        if conditional == false
          raise(Roro::Error.new(msg.join("\n\n")))
        else 
          true 
        end
      end
   
      def confirm_dependencies
        dependencies = [
          {
            system_query: "which docker",
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
          }
        ]

        dependencies.each do |dependency|
          confirm_dependency(dependency)
        end
      end
    end
  end
end