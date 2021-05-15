module Roro
  module Crypto
    # module File 
      module FileReflection
        # include File

        def source_files(dir, pattern)
          Dir.glob(dir + "/**/*#{pattern}")
        end
      
        def gather_environments(dir, ext)
          environments = []
          source_files(dir, ext).each do |file|
            environments << file.split('/').last.split('.').first
          end
          if environments.empty? 
            raise EnvironmentError, "No files in the #{dir} directory matching #{ext}"
          else 
            environments.uniq
          end
        end

        def get_key(environment, dir='roro')
          env_key = environment.upcase + '_KEY'
          key_file = Dir.glob("roro/keys/#{environment}.key").first
          case
          when ENV[env_key].nil? && key_file.nil?
            raise KeyError, "No #{env_key} set. Please set one as a variable or in a file."
          when ENV[env_key]
            ENV[env_key]
          else 
            File.read(key_file).strip
          end
        end
      end
    # end
  end
end