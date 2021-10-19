class Roro::Crypto::FileWriter < Thor
  include Thor::Actions

  no_commands do 

    def write_to_file(filename, content)
      create_file filename, content
    end

    def interpolated_path
      @env[:story]
    end
  end
end