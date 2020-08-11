
module Roro

  class CLI < Thor
    
    no_commands do  

      def choices 
        { default: 'y', limited_to: ["y", "n"] }
      end
      
      def own_if_required
        system 'sudo chown -R $USER .'
      end   
      
      def as_system(command)
        command = OS.linux? ? "sudo #{command}" : command
        system command
      end

      def chown_if_required()
        warning = "It looks like you're running Docker on some flavor of Linux, in which case the files created by your containers are owned by the root user of the container, and not by the user of the host machine. Please change their ownership by supplying your password at the prompt.",
        action = "system 'sudo chown -R $USER .'"
        msg = []
        msg << ""
        msg << delineator
        msg << warning
        msg << ""
        msg.join("\n\n")
        puts msg
        eval(action)
      end

      def delineator
        ("-" * 80)
      end
    end
  end 
end
