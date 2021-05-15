module Roro
  module Crypto
    module File 
      module Reflection

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
      end
    end
  end
end