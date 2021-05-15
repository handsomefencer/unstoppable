module Roro
  module Crypto
    class FileWriter < Thor
      include Thor::Actions

      no_commands do 
  
        def write_to_file(filename, content)
          create_file filename, content
        end
      end
    end
  end
end